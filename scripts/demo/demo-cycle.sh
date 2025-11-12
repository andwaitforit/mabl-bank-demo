#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║          Full Demo Cycle Manager                              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${GREEN}Available Demo Cycle Commands:${NC}"
echo ""
echo -e "  ${CYAN}1. npm run demo:add-and-deploy${NC}    - Add feature → Commit → Deploy"
echo -e "  ${CYAN}2. npm run demo:reset-and-deploy${NC}  - Reset feature → Commit → Deploy"
echo -e "  ${CYAN}3. npm run demo:full-cycle${NC}        - Complete cycle (add → deploy → reset → deploy)"
echo ""
echo -e "${YELLOW}Or use individual scripts:${NC}"
echo -e "  • ${CYAN}sh scripts/demo/add-broken-feature.sh${NC}         - Add the donation feature"
echo -e "  • ${CYAN}sh scripts/demo/fix-feature.sh${NC}                - Fix the donation bug"
echo -e "  • ${CYAN}sh scripts/deployment/commit-and-deploy.sh${NC}    - Commit changes and deploy"
echo -e "  • ${CYAN}sh scripts/deployment/reset-and-commit.sh${NC}     - Reset and optionally deploy"
echo ""

PS3=$'\n'"${YELLOW}Select an option (1-3), or press Ctrl+C to exit: ${NC}"

options=("Add feature and deploy" "Reset feature and deploy" "Full cycle (add → deploy → reset → deploy)" "Exit")

select opt in "${options[@]}"
do
    case $opt in
        "Add feature and deploy")
            echo ""
            echo -e "${BLUE}========================================${NC}"
            echo -e "${BLUE}Option 1: Add Feature & Deploy${NC}"
            echo -e "${BLUE}========================================${NC}"
            echo ""
            
            echo -e "${BLUE}Step 1/2: Adding donation feature...${NC}"
            npm run add-broken-feature
            echo ""
            
            echo -e "${BLUE}Step 2/2: Committing and deploying...${NC}"
            sh scripts/deployment/commit-and-deploy.sh "Add donation feature for demo cycle"
            
            echo -e "${GREEN}✓ Feature added and deployed!${NC}"
            break
            ;;
        "Reset feature and deploy")
            echo ""
            echo -e "${BLUE}========================================${NC}"
            echo -e "${BLUE}Option 2: Reset Feature & Deploy${NC}"
            echo -e "${BLUE}========================================${NC}"
            echo ""
            
            npm run reset-feature
            echo ""
            
            echo -e "${BLUE}Committing reset...${NC}"
            if git diff --quiet src/components/TransactPage.js; then
                echo -e "${YELLOW}No changes to commit.${NC}"
            else
                git add src/components/TransactPage.js
                git commit -m "Reset demo environment to original state

- Restore original TransactPage.js
- Remove donation feature modifications
- Prepare for next demo cycle"
                git push
                
                # Auto-generate version
                current_tags=$(git tag -l "v*-prod" | grep -o 'v[0-9]*\.[0-9]*' | sort -V | tail -1)
                if [ -z "$current_tags" ]; then
                    version_tag="v1.0-prod"
                else
                    version_number=$(echo "$current_tags" | sed 's/v//')
                    major=$(echo "$version_number" | cut -d'.' -f1)
                    minor=$(echo "$version_number" | cut -d'.' -f2)
                    minor=$((minor + 1))
                    version_tag="v${major}.${minor}-prod"
                fi
                
                git tag "$version_tag" -m "Release $version_tag: Reset demo environment"
                git push origin "$version_tag"
                echo ""
                echo -e "${GREEN}✓ Reset committed and deployed with tag ${version_tag}${NC}"
            fi
            break
            ;;
        "Full cycle (add → deploy → reset → deploy)")
            echo ""
            echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
            echo -e "${BLUE}║          Full Demo Cycle                                      ║${NC}"
            echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
            echo ""
            
            echo -e "${CYAN}Phase 1: Add Feature${NC}"
            echo -e "${BLUE}────────────────────────────────────${NC}"
            npm run add-broken-feature
            echo ""
            
            echo -e "${CYAN}Phase 2: Deploy Feature${NC}"
            echo -e "${BLUE}────────────────────────────────────${NC}"
            git add src/components/TransactPage.js
            git commit -m "Add donation feature for demo cycle"
            git push
            
            current_tags=$(git tag -l "v*-prod" | grep -o 'v[0-9]*\.[0-9]*' | sort -V | tail -1)
            if [ -z "$current_tags" ]; then
                version_tag="v1.0-prod"
            else
                version_number=$(echo "$current_tags" | sed 's/v//')
                major=$(echo "$version_number" | cut -d'.' -f1)
                minor=$(echo "$version_number" | cut -d'.' -f2)
                minor=$((minor + 1))
                version_tag="v${major}.${minor}-prod"
            fi
            
            git tag "$version_tag" -m "Release $version_tag: Deploy donation feature"
            git push origin "$version_tag"
            echo -e "${GREEN}✓ Feature deployed with tag ${version_tag}${NC}"
            echo ""
            
            echo -e "${YELLOW}Waiting for deployment to complete...${NC}"
            echo -e "${YELLOW}Press Enter when ready to reset (or Ctrl+C to stop)${NC}"
            read
            
            echo ""
            echo -e "${CYAN}Phase 3: Reset Feature${NC}"
            echo -e "${BLUE}────────────────────────────────────${NC}"
            npm run reset-feature
            echo ""
            
            echo -e "${CYAN}Phase 4: Deploy Reset${NC}"
            echo -e "${BLUE}────────────────────────────────────${NC}"
            if ! git diff --quiet src/components/TransactPage.js; then
                git add src/components/TransactPage.js
                git commit -m "Reset demo environment to original state"
                git push
                
                # Increment version
                version_number=$(echo "$version_tag" | sed 's/v\(.*\)-prod/\1/')
                major=$(echo "$version_number" | cut -d'.' -f1)
                minor=$(echo "$version_number" | cut -d'.' -f2)
                minor=$((minor + 1))
                reset_version_tag="v${major}.${minor}-prod"
                
                git tag "$reset_version_tag" -m "Release $reset_version_tag: Reset demo environment"
                git push origin "$reset_version_tag"
                echo -e "${GREEN}✓ Reset deployed with tag ${reset_version_tag}${NC}"
            fi
            
            echo ""
            echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
            echo -e "${GREEN}║          Full Demo Cycle Complete!                            ║${NC}"
            echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
            echo ""
            echo -e "${BLUE}Deployed versions:${NC}"
            echo -e "  • Feature: ${version_tag}"
            echo -e "  • Reset:   ${reset_version_tag}"
            echo ""
            break
            ;;
        "Exit")
            echo ""
            echo -e "${BLUE}Goodbye!${NC}"
            echo ""
            exit 0
            ;;
        *) 
            echo -e "${RED}Invalid option${NC}"
            ;;
    esac
done

echo ""

