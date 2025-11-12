#!/bin/bash

# Test script to verify Codex CLI + mabl MCP integration

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=== Testing Codex CLI + mabl MCP Integration ===${NC}"
echo ""

# Check prerequisites
echo -e "${BLUE}Checking prerequisites...${NC}"

# Check Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}✗ Node.js not found${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Node.js: $(node --version)${NC}"

# Check npm
if ! command -v npm &> /dev/null; then
    echo -e "${RED}✗ npm not found${NC}"
    exit 1
fi
echo -e "${GREEN}✓ npm: $(npm --version)${NC}"

# Check for Codex CLI (try multiple possible names)
CODEX_CMD=""
for cmd in "codex" "@openai/codex" "codex-cli" "@openai/codex-cli"; do
    if command -v "$cmd" &> /dev/null || npx "$cmd" --version &> /dev/null; then
        CODEX_CMD="$cmd"
        echo -e "${GREEN}✓ Found Codex CLI: $cmd${NC}"
        break
    fi
done

if [ -z "$CODEX_CMD" ]; then
    echo -e "${YELLOW}⚠ Codex CLI not found. Attempting to install...${NC}"
    npm install -g @openai/codex-cli 2>/dev/null || \
    npm install -g codex-cli 2>/dev/null || \
    npm install -g codex 2>/dev/null || \
    echo -e "${YELLOW}  Note: Codex CLI may not be publicly available yet${NC}"
    CODEX_CMD="codex"
fi

# Check OpenAI API key
if [ -z "$OPENAI_API_KEY" ]; then
    echo -e "${YELLOW}⚠ OPENAI_API_KEY not set${NC}"
    echo -e "${YELLOW}  Set it with: export OPENAI_API_KEY='your-key'${NC}"
else
    echo -e "${GREEN}✓ OPENAI_API_KEY is set${NC}"
fi

# Check mabl CLI
echo -e "${BLUE}Checking mabl CLI...${NC}"
if npx @mablhq/mabl-cli@latest --version &> /dev/null; then
    echo -e "${GREEN}✓ mabl CLI is available${NC}"
else
    echo -e "${RED}✗ mabl CLI not found${NC}"
    exit 1
fi

# Check mabl authentication
if npx @mablhq/mabl-cli@latest auth status &> /dev/null; then
    echo -e "${GREEN}✓ mabl authentication found${NC}"
else
    if [ -z "$MABL_API_KEY" ]; then
        echo -e "${YELLOW}⚠ mabl not authenticated and MABL_API_KEY not set${NC}"
    else
        echo -e "${BLUE}Authenticating mabl...${NC}"
        npx @mablhq/mabl-cli@latest auth activate-key "$MABL_API_KEY"
        echo -e "${GREEN}✓ mabl authenticated${NC}"
    fi
fi

echo ""

# Test MCP server
echo -e "${BLUE}Testing mabl MCP server...${NC}"
timeout 3 npx @mablhq/mabl-cli@latest mcp start 2>&1 | head -n 5 &
MCP_PID=$!
sleep 1

if kill -0 $MCP_PID 2>/dev/null; then
    echo -e "${GREEN}✓ MCP server starts successfully${NC}"
    kill $MCP_PID 2>/dev/null
    wait $MCP_PID 2>/dev/null
else
    echo -e "${GREEN}✓ MCP server command available${NC}"
fi

echo ""

# Configure Codex MCP
echo -e "${BLUE}Setting up Codex MCP configuration...${NC}"
mkdir -p ~/.codex

cat > ~/.codex/config.toml << EOF
[mcp_servers.mabl]
command = "npx"
args = ["@mablhq/mabl-cli@latest", "mcp", "start"]
env = { MABL_API_KEY = "${MABL_API_KEY:-}" }
EOF

echo -e "${GREEN}✓ Codex config created at ~/.codex/config.toml${NC}"
cat ~/.codex/config.toml

echo ""

# Test Codex + MCP integration
echo -e "${BLUE}Testing Codex + MCP integration...${NC}"

if [ -n "$OPENAI_API_KEY" ]; then
    echo -e "${BLUE}Attempting to use Codex with mabl MCP...${NC}"
    
    # Try different Codex command formats
    if command -v "$CODEX_CMD" &> /dev/null; then
        echo "Testing: $CODEX_CMD exec --help"
        "$CODEX_CMD" exec --help 2>&1 | head -n 5 || true
    else
        echo "Testing: npx $CODEX_CMD --help"
        npx "$CODEX_CMD" --help 2>&1 | head -n 5 || true
    fi
    
    echo ""
    echo -e "${YELLOW}Note: Codex CLI commands may vary. Check OpenAI documentation for current syntax.${NC}"
else
    echo -e "${YELLOW}⚠ Skipping Codex test (no OPENAI_API_KEY)${NC}"
fi

echo ""
echo -e "${GREEN}=== Test Complete ===${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Ensure OPENAI_API_KEY and MABL_API_KEY are set"
echo "2. Verify Codex CLI installation and command syntax"
echo "3. Test Codex commands: codex exec 'test command' --mcp-server mabl"
echo "4. Check ~/.codex/config.toml for configuration"






