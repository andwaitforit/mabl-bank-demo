#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Demo: mabl Auto-healing vs Traditional Selectors${NC}"
echo "This script demonstrates mabl's auto-healing capabilities compared to traditional Playwright selectors."
echo "Authenticating to the mabl cli"

mabl auth activate-key <your-mabl-cli-auth-key>

# Save original state
echo -e "${BLUE}1. Saving original state...${NC}"
# Stash both Logo.js and LoginPage.js
git add src/components/Logo.js src/components/LoginPage.js
git stash push -m "demo-original-state"

# Start dev server if not running
echo -e "${BLUE}2. Starting dev server...${NC}"
npm start &
sleep 10 # Wait for server to start

# Run initial tests - both should pass
echo -e "${BLUE}3. Running initial tests (both should pass)...${NC}"
echo -e "${BLUE}Running Playwright test...${NC}"
npx playwright test tests/login.spec.js --reporter=list

echo -e "${BLUE}Running mabl test...${NC}"
echo "Note: Please run the mabl resilient login test manually in the mabl app for this step"
echo ""
mabl deployments create --application-id na3sMXGAm4lbvCtFZnTMOw-a --environment-id pGtboI1hJIhF5D51qtrQUQ-e --labels auto-heal-demo --await-completion
read -p "Press [Enter] to continue to the next step..."

# Modify login button to break Playwright selector
echo -e "${BLUE}4. Modifying login button...${NC}"
cat > src/components/LoginPage.js << 'EOL'
import React, { useState } from 'react';
import { Logo } from './Logo';
import { Notif } from './Notif';

export const LoginPage = (props) => {
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
  
    const onSubmitHandler = (event) => {
      event.preventDefault();
      props.loginHandler(username, password);
    }
  
    const onChangeUsername = (event) => {
      setUsername(event.target.value);
    }
  
    const onChangePassword = (event) => {
      setPassword(event.target.value);
    }
  
    return (
      <div id="login-page">
        <div id="login">
          <Logo />
          <Notif message={props.notif.message} style={props.notif.style} />
          <form onSubmit={onSubmitHandler}>
            <label htmlFor="username">Username</label>
            <input id="username" autoComplete="off" onChange={onChangeUsername}  value={username} type="text" />
            <label htmlFor="password">Password</label>
            <input id="password" autoComplete="off" onChange={onChangePassword} value={password} type="password" />
            <button 
              type="submit" 
              className="auth-button primary-action"
              data-testid="auth-submit"
              data-action="authenticate"
              data-tracking="user-auth-btn"
              aria-label="Sign in to your account"
              style={{
                padding: '10px 20px',
                backgroundColor: '#4CAF50',
                color: 'white',
                border: 'none',
                borderRadius: '4px',
                cursor: 'pointer'
              }}
            >
              <span role="img" aria-label="sparkles">✨</span>
              <span>Continue to Account</span>
            </button>
          </form>
        </div>
      </div>
    )
}
EOL

echo "Changed login button with significant modifications:"
echo "1. Changed class from 'btn' to 'auth-button primary-action'"
echo "2. Changed text from 'Login' to '✨ Continue to Account'"
echo "3. Added semantic attributes: data-testid, data-action, data-tracking"
echo "4. Added accessibility attributes: aria-label"
echo "5. Added nested spans for icon and text"
echo "6. Added custom styling while keeping button semantics"
echo ""

# Re-run tests to show difference
echo -e "${BLUE}5. Re-running tests (Playwright should fail, mabl should auto-heal)...${NC}"
echo -e "${BLUE}Running Playwright test...${NC}"
npx playwright test tests/login.spec.js --reporter=list || echo -e "${RED}Playwright test failed as expected${NC}"

mabl deployments create --application-id na3sMXGAm4lbvCtFZnTMOw-a --environment-id pGtboI1hJIhF5D51qtrQUQ-e --labels auto-heal-demo --await-completion
echo -e "${BLUE}Running mabl test...${NC}"
echo "Note: Please run the mabl resilient login test manually in the mabl app for this step"
echo "The test should auto-heal and pass despite the changes"
echo ""
read -p "Press [Enter] to continue to the next step..."

# Reset to original state
echo -e "${BLUE}6. Resetting to original state...${NC}"
# Clean up test artifacts and force restore original state
rm -rf test-results/
git checkout src/components/LoginPage.js
git stash pop
echo -e "${GREEN}Demo complete! Original state restored.${NC}"

# Cleanup
pkill -f "react-scripts start" || true
