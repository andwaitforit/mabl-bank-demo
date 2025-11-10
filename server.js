const express = require('express');
const cors = require('cors');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

// Parks and Recreation businesses stock data
const availableStocks = [
  { symbol: 'SWANSON', name: 'Swanson Foods', basePrice: 45.50 },
  { symbol: 'LITTLES', name: 'Little Sebastian Memorial', basePrice: 120.00 },
  { symbol: 'PAWN', name: 'Pawn Shop', basePrice: 15.25 },
  { symbol: 'RENT', name: 'Rent-A-Swag', basePrice: 32.75 },
  { symbol: 'TOMS', name: 'Tom\'s Bistro', basePrice: 28.50 },
  { symbol: 'JJ', name: 'JJ\'s Diner', basePrice: 18.90 },
  { symbol: 'PIT', name: 'The Pit', basePrice: 22.30 },
  { symbol: 'SWEET', name: 'Sweetums', basePrice: 55.00 },
  { symbol: 'GRIZ', name: 'Gryzzl', basePrice: 95.75 },
  { symbol: 'ENT', name: 'Entertainment 720', basePrice: 0.05 }
];

// Generate fake stock prices with random fluctuations
function generateStockPrice(basePrice) {
  const changePercent = (Math.random() * 10 - 5) / 100; // -5% to +5%
  const price = basePrice * (1 + changePercent);
  return Math.round(price * 100) / 100;
}

// GET all available stocks
app.get('/api/stocks', (req, res) => {
  const stocks = availableStocks.map(stock => ({
    symbol: stock.symbol,
    name: stock.name,
    price: generateStockPrice(stock.basePrice),
    change: (Math.random() * 10 - 5).toFixed(2),
    changePercent: ((Math.random() * 10 - 5) / 100).toFixed(2)
  }));
  res.json(stocks);
});

// GET specific stock by symbol
app.get('/api/stocks/:symbol', (req, res) => {
  const stock = availableStocks.find(s => s.symbol === req.params.symbol);
  if (!stock) {
    return res.status(404).json({ error: 'Stock not found' });
  }
  
  const price = generateStockPrice(stock.basePrice);
  const change = (Math.random() * 10 - 5).toFixed(2);
  const changePercent = ((Math.random() * 10 - 5) / 100).toFixed(2);
  
  res.json({
    symbol: stock.symbol,
    name: stock.name,
    price: price,
    change: change,
    changePercent: changePercent
  });
});

// GET multiple stocks by symbols (comma-separated)
app.get('/api/stocks/batch/:symbols', (req, res) => {
  const symbols = req.params.symbols.split(',');
  const stocks = symbols.map(symbol => {
    const stock = availableStocks.find(s => s.symbol === symbol.trim());
    if (stock) {
      const price = generateStockPrice(stock.basePrice);
      const change = (Math.random() * 10 - 5).toFixed(2);
      const changePercent = ((Math.random() * 10 - 5) / 100).toFixed(2);
      return {
        symbol: stock.symbol,
        name: stock.name,
        price: price,
        change: change,
        changePercent: changePercent
      };
    }
    return null;
  }).filter(Boolean);
  
  res.json(stocks);
});

// Serve static files from React build (only in production/Docker)
if (process.env.NODE_ENV === 'production') {
  app.use(express.static(path.join(__dirname, 'build')));
  
  // Handle React Router - send all non-API requests to index.html
  app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'build', 'index.html'));
  });
}

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
  if (process.env.NODE_ENV === 'production') {
    console.log('Serving React app and API from single server');
  } else {
    console.log('API only mode - use separate React dev server');
  }
});

