#!/bin/bash

# Colors for output
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

clear

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║         Banking App - Available NPM Commands                  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${GREEN}🔧 DEVELOPMENT${NC}"
echo -e "  ${CYAN}npm start${NC}                    - Start React dev server (port 3000)"
echo -e "  ${CYAN}npm run server${NC}              - Start backend API (port 3001)"
echo -e "  ${CYAN}npm run build${NC}               - Build for production"
echo ""

echo -e "${GREEN}🧪 TESTING${NC}"
echo -e "  ${CYAN}npm test${NC}                    - Run React unit tests"
echo -e "  ${CYAN}npm run test:playwright${NC}     - Run all Playwright tests"
echo -e "  ${CYAN}npm run test:playwright:ui${NC}  - Run Playwright with UI"
echo -e "  ${CYAN}npm run test:donation${NC}       - Run donation feature tests"
echo -e "  ${CYAN}npm run test:api${NC}            - Test backend API endpoints"
echo -e "  ${CYAN}npm run test:codex-mcp${NC}      - Run codex MCP tests"
echo ""

echo -e "${GREEN}🎭 DEMO SCRIPTS${NC}"
echo -e "  ${YELLOW}npm run autoheal${NC}            - Auto-healing demo (mabl vs Playwright)"
echo -e "  ${YELLOW}npm run add-broken-feature${NC}  - Add buggy donation feature"
echo -e "  ${YELLOW}npm run fix-feature${NC}         - Fix the donation feature bug"
echo -e "  ${YELLOW}npm run reset-feature${NC}       - Reset to original state"
echo ""

echo -e "${GREEN}🚀 DEMO DEPLOYMENT${NC}"
echo -e "  ${YELLOW}npm run commit-and-deploy${NC}   - Commit changes & deploy with tag"
echo -e "  ${YELLOW}npm run reset-and-commit${NC}    - Reset & optionally deploy"
echo -e "  ${YELLOW}npm run demo:cycle${NC}          - Interactive demo cycle manager"
echo -e "  ${YELLOW}npm run demo:add-and-deploy${NC} - Add feature → commit → deploy"
echo -e "  ${YELLOW}npm run demo:reset-and-deploy${NC} - Reset feature → commit → deploy"
echo -e "  ${YELLOW}npm run demo:full${NC}           - Run complete donation demo (no deploy)"
echo ""

echo -e "${GREEN}🐳 DOCKER${NC}"
echo -e "  ${CYAN}npm run docker:up${NC}           - Start Docker containers (local build)"
echo -e "  ${CYAN}npm run docker:down${NC}         - Stop Docker containers"
echo -e "  ${CYAN}npm run docker:logs${NC}         - View container logs"
echo -e "  ${CYAN}npm run docker:pull${NC}         - Pull images from GHCR"
echo -e "  ${CYAN}npm run docker:ghcr${NC}         - Start using GHCR images"
echo -e "  ${CYAN}npm run docker:ghcr:down${NC}    - Stop GHCR containers"
echo ""

echo -e "${GREEN}🚀 DEPLOYMENT${NC}"
echo -e "  ${CYAN}npm run predeploy${NC}           - Build before deploy"
echo -e "  ${CYAN}npm run deploy${NC}              - Deploy to GitHub Pages"
echo ""

echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}💡 QUICK START EXAMPLES${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}Run the donation demo:${NC}"
echo -e "  $ npm run demo:full"
echo ""

echo -e "${YELLOW}Develop locally (2 terminals):${NC}"
echo -e "  Terminal 1: $ npm run server"
echo -e "  Terminal 2: $ npm start"
echo ""

echo -e "${YELLOW}Run with Docker:${NC}"
echo -e "  $ npm run docker:up"
echo -e "  Visit: http://localhost:3000"
echo ""

echo -e "${YELLOW}Test everything:${NC}"
echo -e "  $ npm start              ${GREEN}# Terminal 1${NC}"
echo -e "  $ npm run test:playwright ${GREEN}# Terminal 2${NC}"
echo ""

echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}📚 DOCUMENTATION${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "  • Main README:           ${CYAN}README.md${NC}"
echo -e "  • NPM Scripts Reference: ${CYAN}docs/NPM_SCRIPTS_REFERENCE.md${NC}"
echo -e "  • Donation Demo Guide:   ${CYAN}docs/DONATION_FEATURE_DEMO.md${NC}"
echo -e "  • Docker Testing:        ${CYAN}docs/DOCKER_TESTING.md${NC}"
echo -e "  • API Documentation:     ${CYAN}docs/API_DOCUMENTATION.md${NC}"
echo ""

echo -e "${GREEN}✨ For more details: ${CYAN}cat docs/NPM_SCRIPTS_REFERENCE.md${NC}"
echo ""

