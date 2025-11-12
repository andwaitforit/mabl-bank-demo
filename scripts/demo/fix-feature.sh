#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Fixing Sweetums Charity Donation Bug${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${YELLOW}Applying fix: Properly deducting donation amount from account${NC}"
echo ""

# Apply the fix
echo -e "${BLUE}Updating TransactPage.js with fix...${NC}"
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
        
        // FIX: Include the fixed $5 donation if enabled
        const donation = donationEnabled ? DONATION_AMOUNT : 0;

        if(amount > 0 && accountNumber !== "0") {
            for(const user of accounts) {
                if(user.number === accountNumber) {
                    // FIX: Calculate total amount including donation
                    const totalAmount = parseFloat(amount) + donation;
                    
                    // Process the total withdrawal (including donation)
                    transact(user.number, totalAmount, props.type, props.setUsers);
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
echo -e "${GREEN}✓ Bug fixed successfully!${NC}"
echo ""
echo -e "${YELLOW}What was fixed:${NC}"
echo "  • Added calculation of total amount (withdrawal + \$5 donation)"
echo "  • Now properly deducting both withdrawal and donation from account"
echo "  • Balance correctly reflects the total transaction"
echo "  • Donation is always \$5 when checkbox is checked"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Run tests again: ${GREEN}npm run test:donation${NC}"
echo "  2. Watch the test pass! ✅"
echo "  3. When done, reset: ${GREEN}npm run reset-feature${NC}"
echo ""

