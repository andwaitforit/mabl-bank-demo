#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Adding Sweetums Charity Donation Feature${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${YELLOW}Scenario: Developer adds a new feature to allow donations during withdrawals${NC}"
echo -e "${YELLOW}Bug: The donation amount is not properly deducted from the account${NC}"
echo ""

# Save original state if not already saved
if [ ! -f ".original-transact-page.backup" ]; then
    echo -e "${BLUE}Backing up original TransactPage.js...${NC}"
    cp src/components/TransactPage.js .original-transact-page.backup
fi

# Create the buggy version with donation feature
echo -e "${BLUE}Adding donation feature with bug...${NC}"
cat > src/components/TransactPage.js << 'EOL'
import { useState } from "react";
import { Notif } from "./Notif";
import { formatNumber, findAccount, transact, trim, capitalize } from "./Utils";

export const TransactPage = (props) => {
    const users = JSON.parse(localStorage.getItem('users'));
    const setNotif = props.setNotif;
    const notif = props.notif;
    const [accounts, setAccounts] = useState(users);
    const [selectedAccount, setSelectedAccount] = useState({balance: 0});
    const [depositAmount, setDepositAmount] = useState(0);
    const [donationEnabled, setDonationEnabled] = useState(false);
    
    const DONATION_AMOUNT = 5; // Fixed $5 donation to Sweetums Charity

    const options = accounts.map((user, index) => {
        return <option key={index} value={user.number}>{user.fullname} #{user.number}</option>
    });

    const displayBalance = (e) => {
        setNotif(notif);
        const selectedNumber = e.target.value;
        
        for(const user of accounts) {
            if(user.number === selectedNumber) {
                setSelectedAccount(user);
                break;
            }
        }
    }

    const onDeposit = (e) => {
        const rawValue = e.target.value;
        const amount = trim(rawValue);
        setDepositAmount(amount);
    }

    const onDonationToggle = () => {
        setDonationEnabled(prev => !prev);
    }

    const processTransfer = (e) => {
        e.preventDefault();
        const amount = trim(e.target.elements.amount.value);
        const accountNumber = e.target.elements.account.value;

        if(amount > 0 && accountNumber !== "0") {
            for(const user of accounts) {
                if(user.number === accountNumber) {
                    // BUG: Only processing the main amount, not including donation
                    transact(user.number, amount, props.type, props.setUsers);
                    setSelectedAccount(findAccount(user.number));
                    setAccounts(JSON.parse(localStorage.getItem('users')));
                    setDepositAmount(0);
                    setDonationEnabled(false);
                    
                    let message = `${capitalize(props.page)} successful.`;
                    if (donationEnabled) {
                        message += ` Thank you for your $${DONATION_AMOUNT} donation to Sweetums Charity!`;
                    }
                    setNotif({message: message, style: 'success'});
                    break;
                }
            }
        } 
        else {
            setNotif({message: `${capitalize(props.page)} failed.`, style: 'danger'});
        }
    }

    const icon = props.page === 'withdraw' ? 'bx bx-down-arrow-alt' : 'bx bx-up-arrow-alt';
    const showDonation = props.page === 'withdraw';

    return (
        <section id="main-content">
            <form id="form" onSubmit={processTransfer}>
                <h1>{props.page}</h1>
                <Notif message={notif.message} style={notif.style} />
                <label>Account</label>
                <select name="account" onChange={displayBalance}>
                    <option value="0">Select Account</option>
                    {options}
                </select>

                <label>Current balance</label>
                <input type="text" className="right" value={formatNumber(selectedAccount.balance)} disabled />
                
                <div className="transfer-icon"><i className={icon}></i></div>
                <label>Amount to {props.page}</label>
                <input type="text" name="amount" value={depositAmount || ''} onChange={onDeposit} autoComplete="off" className="right big-input" placeholder="0.00" />
                
                {showDonation && (
                    <div style={{marginTop: '20px', padding: '15px', backgroundColor: '#f0f8ff', borderRadius: '5px', border: '1px solid #4CAF50'}}>
                        <div style={{display: 'flex', alignItems: 'center', cursor: 'pointer'}} onClick={onDonationToggle}>
                            <input 
                                type="checkbox" 
                                id="donation-toggle"
                                checked={donationEnabled}
                                onChange={onDonationToggle}
                                readOnly
                                style={{marginRight: '10px', cursor: 'pointer', width: '18px', height: '18px', pointerEvents: 'none'}}
                            />
                            <span style={{fontSize: '16px', fontWeight: '500', userSelect: 'none'}}>
                                Donate $5 to Sweetums Charity 🍬
                            </span>
                        </div>
                    </div>
                )}
                
                <button type="submit" className="btn">{props.page}</button>
            </form>
        </section>
    )
}
EOL

echo ""
echo -e "${GREEN}✓ Feature added successfully!${NC}"
echo ""
echo -e "${YELLOW}What was changed:${NC}"
echo "  • Added checkbox for fixed \$5 donation to Sweetums Charity"
echo "  • Checkbox only appears on withdrawal page"
echo "  • Added thank you message when donation is made"
echo "  • Improved checkbox styling for better clickability"
echo ""
echo -e "${RED}What's broken:${NC}"
echo "  • The \$5 donation is NOT being deducted from the account"
echo "  • Only the withdrawal amount is processed, donation is ignored"
echo "  • User thinks they donated \$5 but their balance doesn't reflect it"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Run: ${GREEN}npm start${NC} (in another terminal)"
echo "  2. Run tests: ${GREEN}npm run test:donation${NC}"
echo "  3. Watch the test fail and catch the bug!"
echo "  4. Fix the bug: ${GREEN}npm run fix-feature${NC}"
echo ""

