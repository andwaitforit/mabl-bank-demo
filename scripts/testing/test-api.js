/**
 * Simple test script for Stock Tracker API
 * Run with: node scripts/test-api.js
 * Make sure the server is running on port 3001 first
 */

const BASE_URL = 'http://localhost:3001/api';

// Test helper function
async function testEndpoint(name, url, expectedStatus = 200) {
  try {
    console.log(`\n🧪 Testing: ${name}`);
    console.log(`   URL: ${url}`);
    
    const response = await fetch(url);
    const data = await response.json();
    
    if (response.status === expectedStatus) {
      console.log(`   ✅ Status: ${response.status} (Expected: ${expectedStatus})`);
      console.log(`   📦 Response:`, JSON.stringify(data, null, 2).substring(0, 200) + '...');
      return { success: true, data };
    } else {
      console.log(`   ❌ Status: ${response.status} (Expected: ${expectedStatus})`);
      return { success: false, data };
    }
  } catch (error) {
    console.log(`   ❌ Error: ${error.message}`);
    return { success: false, error: error.message };
  }
}

// Run all tests
async function runTests() {
  console.log('🚀 Starting API Tests...');
  console.log('='.repeat(50));
  
  // Test 1: Get all stocks
  await testEndpoint(
    'Get All Stocks',
    `${BASE_URL}/stocks`
  );
  
  // Test 2: Get single stock (valid)
  await testEndpoint(
    'Get Single Stock (Valid)',
    `${BASE_URL}/stocks/SWANSON`
  );
  
  // Test 3: Get single stock (invalid)
  await testEndpoint(
    'Get Single Stock (Invalid)',
    `${BASE_URL}/stocks/INVALID`,
    404
  );
  
  // Test 4: Get batch stocks (valid)
  await testEndpoint(
    'Get Batch Stocks (Valid)',
    `${BASE_URL}/stocks/batch/SWANSON,LITTLES,PAWN`
  );
  
  // Test 5: Get batch stocks (mixed valid/invalid)
  await testEndpoint(
    'Get Batch Stocks (Mixed)',
    `${BASE_URL}/stocks/batch/SWANSON,INVALID,PAWN`
  );
  
  // Test 6: Verify price changes
  console.log('\n🔄 Testing Price Randomization...');
  const result1 = await testEndpoint('First Request', `${BASE_URL}/stocks/SWANSON`);
  await new Promise(resolve => setTimeout(resolve, 100)); // Small delay
  const result2 = await testEndpoint('Second Request', `${BASE_URL}/stocks/SWANSON`);
  
  if (result1.success && result2.success) {
    const price1 = result1.data.price;
    const price2 = result2.data.price;
    if (price1 !== price2) {
      console.log(`   ✅ Prices are different: $${price1} vs $${price2} (Randomization working)`);
    } else {
      console.log(`   ⚠️  Prices are the same: $${price1} (May happen by chance)`);
    }
  }
  
  console.log('\n' + '='.repeat(50));
  console.log('✨ Tests Complete!');
}

// Check if fetch is available (Node.js 18+)
if (typeof fetch === 'undefined') {
  console.error('❌ This script requires Node.js 18+ or install node-fetch');
  console.log('   Install: npm install node-fetch');
  console.log('   Or use: node --experimental-fetch scripts/test-api.js');
  process.exit(1);
}

// Run tests
runTests().catch(error => {
  console.error('❌ Test suite failed:', error);
  process.exit(1);
});

