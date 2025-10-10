const { test, expect } = require('@playwright/test');

// Using credentials from README: client@client.com / abc123
const CLIENT_EMAIL = 'client@client.com';
const CLIENT_PASSWORD = 'abc123';

// Helper function to highlight an element before interacting
async function highlightElement(page, selector, color = 'green') {
  const element = await page.locator(selector);
  await element.scrollIntoViewIfNeeded();
  await page.evaluate(({ sel, col }) => {
    const elem = document.querySelector(sel);
    if (elem) {
      const originalTransition = elem.style.transition;
      elem.style.transition = 'all 0.5s ease-in-out';
      elem.style.boxShadow = `0 0 15px 5px ${col}`;
      setTimeout(() => {
        elem.style.boxShadow = 'none';
        elem.style.transition = originalTransition;
      }, 1000);
    }
  }, { sel: selector, col: color });
  await page.waitForTimeout(1500); // Wait for highlight animation
}

test.describe('Login smoke', () => {
  test('client can login and see sidebar Home', async ({ page }) => {
    // Add smooth scrolling for better visuals
    await page.addStyleTag({
      content: '* { scroll-behavior: smooth !important; }'
    });

    // Enable console logging for debugging
    page.on('console', msg => console.log(msg.text()));

    console.log('Navigating to login page...');
    await page.goto('/');
    await page.waitForTimeout(1000); // Let page settle
    
    // Take screenshot of initial page
    await page.screenshot({ path: 'test-results/01-login-page.png' });
    
    console.log('Waiting for login form...');
    await page.waitForSelector('#login-page');

    // Fill username/password and submit with visual feedback
    console.log('Filling username...');
    await highlightElement(page, '#username');
    await page.fill('#username', CLIENT_EMAIL, { delay: 100 }); // Slower typing

    console.log('Filling password...');
    await highlightElement(page, '#password');
    await page.fill('#password', CLIENT_PASSWORD, { delay: 100 }); // Slower typing
    
    // Screenshot before clicking login
    await page.screenshot({ path: 'test-results/02-credentials-filled.png' });
    
    console.log('Clicking login button...');
    const loginButton = await page.locator('button.btn:has-text("Login")');
    await highlightElement(page, 'button.btn');
    await loginButton.click();

    console.log('Waiting for dashboard...');
    // After login, sidebar should contain text 'Home'
    console.log('Waiting for dashboard...');
    await page.waitForTimeout(2000); // Give more time for navigation
    const homeLink = await page.getByRole('link', { name: 'Home' });
    await expect(homeLink).toBeVisible({ timeout: 30000 });
    console.log('Test complete - Home link found!');
    
    // Final screenshot of success state
    await page.screenshot({ path: 'test-results/03-logged-in.png' });
    console.log('Login test complete!');
  });
});
