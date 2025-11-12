#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Commit & Deploy Changes${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if there are changes to commit
if git diff --quiet && git diff --staged --quiet; then
    echo -e "${YELLOW}No changes to commit.${NC}"
    exit 0
fi

# Step 1: Show changes
echo -e "${BLUE}Step 1: Changes to be committed:${NC}"
git status --short
echo ""

# Step 2: Get commit message
if [ -z "$1" ]; then
    echo -e "${YELLOW}Enter commit message (or press Enter for default):${NC}"
    read -r commit_message
    if [ -z "$commit_message" ]; then
        commit_message="Add donation feature for demo cycle"
    fi
else
    commit_message="$1"
fi

# Step 3: Stage and commit
echo -e "${BLUE}Step 2: Committing changes...${NC}"
git add src/components/TransactPage.js
git commit -m "$commit_message"
echo -e "${GREEN}✓ Changes committed${NC}"
echo ""

# Step 4: Push commit
echo -e "${BLUE}Step 3: Pushing commit...${NC}"
git push
echo -e "${GREEN}✓ Commit pushed${NC}"
echo ""

# Step 5: Get next version number
current_tags=$(git tag -l "v*-prod" | grep -o 'v[0-9]*\.[0-9]*' | sort -V | tail -1)
if [ -z "$current_tags" ]; then
    next_version="v1.0"
else
    # Extract major.minor and increment minor
    version_number=$(echo "$current_tags" | sed 's/v//')
    major=$(echo "$version_number" | cut -d'.' -f1)
    minor=$(echo "$version_number" | cut -d'.' -f2)
    minor=$((minor + 1))
    next_version="v${major}.${minor}"
fi

echo -e "${YELLOW}Suggested next version: ${next_version}-prod${NC}"
echo -e "${YELLOW}Enter version tag (or press Enter to use suggested):${NC}"
read -r version_tag

if [ -z "$version_tag" ]; then
    version_tag="${next_version}-prod"
fi

# Step 6: Create and push tag
echo ""
echo -e "${BLUE}Step 4: Creating release tag ${version_tag}...${NC}"
git tag "$version_tag" -m "Release $version_tag: Deploy changes"
echo -e "${GREEN}✓ Tag created${NC}"
echo ""

echo -e "${BLUE}Step 5: Pushing tag to trigger deployment...${NC}"
git push origin "$version_tag"
echo -e "${GREEN}✓ Tag pushed${NC}"
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Deployment Triggered!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Monitor workflow at:${NC}"
echo -e "https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:/]\(.*\)\.git/\1/')/actions"
echo ""
echo -e "${BLUE}This will trigger:${NC}"
echo "  1. Build and push Docker images"
echo "  2. Run mabl regression tests"
echo "  3. Deploy to TrueNAS"
echo "  4. Run mabl smoke tests"
echo ""

