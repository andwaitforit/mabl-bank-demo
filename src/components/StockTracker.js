import React, { useState, useEffect } from 'react';

export const StockTracker = () => {
  const [availableStocks, setAvailableStocks] = useState([]);
  const [trackedStocks, setTrackedStocks] = useState([]);
  const [stockData, setStockData] = useState({});
  const [loading, setLoading] = useState(false);
  const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:3001/api';

  // Load tracked stocks from localStorage on mount
  useEffect(() => {
    const saved = localStorage.getItem('trackedStocks');
    if (saved) {
      const symbols = JSON.parse(saved);
      setTrackedStocks(symbols);
    }
  }, []);

  // Fetch available stocks
  useEffect(() => {
    fetchAvailableStocks();
  }, []);

  // Fetch stock data for tracked stocks
  useEffect(() => {
    if (trackedStocks.length > 0) {
      fetchStockData();
      const interval = setInterval(fetchStockData, 5000); // Update every 5 seconds
      return () => clearInterval(interval);
    }
  }, [trackedStocks]);

  const fetchAvailableStocks = async () => {
    try {
      const response = await fetch(`${API_URL}/stocks`);
      const data = await response.json();
      setAvailableStocks(data);
    } catch (error) {
      console.error('Error fetching stocks:', error);
    }
  };

  const fetchStockData = async () => {
    if (trackedStocks.length === 0) return;
    
    setLoading(true);
    try {
      const symbols = trackedStocks.join(',');
      const response = await fetch(`${API_URL}/stocks/batch/${symbols}`);
      const data = await response.json();
      
      const stockMap = {};
      data.forEach(stock => {
        stockMap[stock.symbol] = stock;
      });
      setStockData(stockMap);
    } catch (error) {
      console.error('Error fetching stock data:', error);
    } finally {
      setLoading(false);
    }
  };

  const addStock = (symbol) => {
    if (!trackedStocks.includes(symbol)) {
      const updated = [...trackedStocks, symbol];
      setTrackedStocks(updated);
      localStorage.setItem('trackedStocks', JSON.stringify(updated));
    }
  };

  const removeStock = (symbol) => {
    const updated = trackedStocks.filter(s => s !== symbol);
    setTrackedStocks(updated);
    localStorage.setItem('trackedStocks', JSON.stringify(updated));
    
    const newStockData = { ...stockData };
    delete newStockData[symbol];
    setStockData(newStockData);
  };

  const getChangeColor = (change) => {
    const numChange = parseFloat(change);
    if (numChange > 0) return '#00A86B';
    if (numChange < 0) return '#DC143C';
    return '#444E61';
  };

  const getChangeIcon = (change) => {
    const numChange = parseFloat(change);
    if (numChange > 0) return '↗';
    if (numChange < 0) return '↘';
    return '→';
  };

  return (
    <div id="main-content">
      <h1 className="main">Parks & Rec Stock Tracker</h1>
      
      <div id="form" className="stock-tracker">
        <h2>Tracked Stocks</h2>
        
        {trackedStocks.length === 0 ? (
          <p style={{ color: '#444E61', marginTop: '1rem' }}>
            No stocks tracked yet. Add stocks from the list below.
          </p>
        ) : (
          <div className="stock-list">
            {trackedStocks.map(symbol => {
              const stock = stockData[symbol];
              if (!stock) return null;
              
              return (
                <div key={symbol} className="stock-card">
                  <div className="stock-header">
                    <div>
                      <h3>{stock.symbol}</h3>
                      <p className="stock-name">{stock.name}</p>
                    </div>
                    <button 
                      className="btn-remove"
                      onClick={() => removeStock(symbol)}
                      aria-label={`Remove ${stock.name}`}
                    >
                      ×
                    </button>
                  </div>
                  <div className="stock-price">
                    <span className="price">${stock.price.toFixed(2)}</span>
                    <span 
                      className="change" 
                      style={{ color: getChangeColor(stock.change) }}
                    >
                      {getChangeIcon(stock.change)} ${Math.abs(stock.change).toFixed(2)} 
                      ({stock.changePercent > 0 ? '+' : ''}{stock.changePercent}%)
                    </span>
                  </div>
                </div>
              );
            })}
          </div>
        )}

        <h2 style={{ marginTop: '2rem' }}>Available Stocks</h2>
        <div className="available-stocks">
          {availableStocks
            .filter(stock => !trackedStocks.includes(stock.symbol))
            .map(stock => (
              <div key={stock.symbol} className="stock-card available">
                <div className="stock-header">
                  <div>
                    <h3>{stock.symbol}</h3>
                    <p className="stock-name">{stock.name}</p>
                  </div>
                  <button 
                    className="btn-add"
                    onClick={() => addStock(stock.symbol)}
                  >
                    + Add
                  </button>
                </div>
                <div className="stock-price">
                  <span className="price">${stock.price.toFixed(2)}</span>
                </div>
              </div>
            ))}
        </div>
      </div>
    </div>
  );
};

