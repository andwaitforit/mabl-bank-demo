#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Reset Demo & Commit Changes${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Step 1: Run reset-feature
echo -e "${BLUE}Step 1: Running reset-feature...${NC}"
npm run reset-feature

# Check if reset was successful (backup file existed)
if [ ! -f ".original-transact-page.backup" ] && [ -f "src/components/TransactPage.js" ]; then
    echo ""
    echo -e "${BLUE}Step 2: Checking for changes...${NC}"
    
    # Check if there are any changes to commit
    if git diff --quiet src/components/TransactPage.js; then
        echo -e "${YELLOW}No changes to commit. TransactPage.js is already in original state.${NC}"
        exit 0
    fi
    
    echo -e "${GREEN}✓ Changes detected${NC}"
    echo ""
    
    # Step 2: Stage the changes
    echo -e "${BLUE}Step 3: Staging changes...${NC}"
    git add src/components/TransactPage.js
    echo -e "${GREEN}✓ Changes staged${NC}"
    echo ""
    
    # Step 3: Commit the changes
    echo -e "${BLUE}Step 4: Committing changes...${NC}"
    git commit -m "Reset demo environment to original state

- Restore original TransactPage.js
- Remove donation feature modifications
- Prepare for next demo cycle"
    echo -e "${GREEN}✓ Changes committed${NC}"
    echo ""
    
    # Step 4: Ask about pushing
    echo -e "${YELLOW}Would you like to push these changes? (y/n)${NC}"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo ""
        echo -e "${BLUE}Step 5: Pushing to remote...${NC}"
        git push
        echo -e "${GREEN}✓ Changes pushed to remote${NC}"
        echo ""
        
        # Step 5: Ask about creating deployment tag
        echo -e "${YELLOW}Would you like to create a release tag to trigger deployment? (y/n)${NC}"
        read -r tag_response
        if [[ "$tag_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            # Get next version number
            current_tags=$(git tag -l "v*-prod" | grep -o 'v[0-9]*\.[0-9]*' | sort -V | tail -1)
            if [ -z "$current_tags" ]; then
                next_version="v1.0"
            else
                version_number=$(echo "$current_tags" | sed 's/v//')
                major=$(echo "$version_number" | cut -d'.' -f1)
                minor=$(echo "$version_number" | cut -d'.' -f2)
                minor=$((minor + 1))
                next_version="v${major}.${minor}"
            fi
            
            echo ""
            echo -e "${YELLOW}Suggested next version: ${next_version}-prod${NC}"
            echo -e "${YELLOW}Enter version tag (or press Enter to use suggested):${NC}"
            read -r version_tag
            
            if [ -z "$version_tag" ]; then
                version_tag="${next_version}-prod"
            fi
            
            echo ""
            echo -e "${BLUE}Step 6: Creating and pushing tag ${version_tag}...${NC}"
            git tag "$version_tag" -m "Release $version_tag: Reset demo environment"
            git push origin "$version_tag"
            echo -e "${GREEN}✓ Tag created and pushed${NC}"
            echo ""
        fi
    else
        echo ""
        echo -e "${YELLOW}Skipping push. Run 'git push' manually when ready.${NC}"
        echo ""
    fi
    
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}Demo environment reset and committed!${NC}"
    echo -e "${GREEN}========================================${NC}"
else
    echo ""
    echo -e "${YELLOW}No commit needed - backup not found or already in original state.${NC}"
fi

echo ""

