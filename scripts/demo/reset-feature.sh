#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Resetting to Original State${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

if [ -f ".original-transact-page.backup" ]; then
    echo -e "${BLUE}Restoring original TransactPage.js...${NC}"
    cp .original-transact-page.backup src/components/TransactPage.js
    rm .original-transact-page.backup
    echo -e "${GREEN}✓ Original state restored!${NC}"
    echo ""
    echo -e "${YELLOW}Cleanup complete:${NC}"
    echo "  • TransactPage.js reverted to original"
    echo "  • Donation feature removed"
    echo "  • Backup file deleted"
else
    echo -e "${YELLOW}No backup found. Nothing to restore.${NC}"
    echo "Run ${GREEN}npm run add-broken-feature${NC} first to create a backup."
fi

echo ""
echo -e "${BLUE}Ready for next demo cycle!${NC}"
echo ""

