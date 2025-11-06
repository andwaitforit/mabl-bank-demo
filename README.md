# Banking App in ReactJS

![Banking App Screenshot](screen.png)

The user is a bank employee who manually manages the bank's accounts.
He does the creation of account manually using the account holders name and sets the initial balance of the account if possible.

He also does the withdrawal and deposit manually for each account.
He also does the transfer of balances if there are requests for it.
Your task is to help this poor employee out by creating a simple admin banking app


## Objective
A banking app created with ReactJS that we can test with both mabl and playwright. Included is a shell script
that will run tests with both platforms twice.  Initially we will run the tests against the original state of 
the application.  The script will then apply a UI change to our login button as one might expect changes to occur
in typical dev cycles.  We will then re-run the tests in both mabl and playwright and as expected the playwright
test will fail while mabl will pass.  Once completed the application state will be restored to the original version 
using git stash.

Since this test will be running again your local environment you'll want to deploy the mabl link agent, and configure
your local host as a dev environment in your workspace.  Additionally within the demo-auto-healing.sh you'll need to
replace the api key with your own cli auth key.

## To start the dev server
NODE_OPTIONS=--openssl-legacy-provider npm start

## To start the backend API server (for Stock Tracker)
npm run server

The backend API runs on http://localhost:3001 and provides fake stock data for Parks & Recreation businesses.

**Note:** You'll need to run both the backend server and the React app in separate terminal windows for the Stock Tracker to work.

## To run the demo script 
sh demo-auto-healing.sh

## Docker Deployment

The application can be deployed using Docker containers. Both the frontend and backend API are containerized.

### Prerequisites
- Docker and Docker Compose installed on your system

### Quick Start with Docker Compose

1. **Build and start all services:**
   ```bash
   docker-compose up --build
   ```

2. **Run in detached mode (background):**
   ```bash
   docker-compose up -d --build
   ```

3. **Access the application:**
   - Frontend: http://localhost:3000
   - API: http://localhost:3001

4. **Stop the containers:**
   ```bash
   docker-compose down
   ```

### Building Individual Containers

**Frontend only:**
```bash
docker build -t banking-app-frontend .
docker run -p 3000:80 banking-app-frontend
```

**API only:**
```bash
docker build -f Dockerfile.api -t banking-app-api .
docker run -p 3001:3001 banking-app-api
```

### Environment Variables

The frontend container accepts a build argument for the API URL:
```bash
docker build --build-arg REACT_APP_API_URL=http://your-api-url/api -t banking-app-frontend .
```

### Docker Compose Configuration

The `docker-compose.yml` file orchestrates both services:
- **frontend**: React app served via nginx (port 3000)
- **api**: Node.js Express API server (port 3001)

The frontend automatically connects to the API service using Docker's internal networking.

### Testing Docker Deployment

For detailed testing instructions, see:
- [Docker Testing Guide](./docs/DOCKER_TESTING.md)

Quick test:
```bash
# Build and start
docker-compose up --build

# In another terminal, test the API
curl http://localhost:3001/api/stocks

# Open browser to http://localhost:3000
```

## Demo Account Credentials

Use the following credentials to test the app.

### For Admin
```
email: admin
password: admin
```

### For Client
```
email: client@client.com
password: abc123
```

## Stock Tracker Feature

The app includes a Stock Tracker module that displays fake stock prices for businesses from Parks & Recreation:
- Swanson Foods (SWANSON)
- Little Sebastian Memorial (LITTLES)
- Pawn Shop (PAWN)
- Rent-A-Swag (RENT)
- Tom's Bistro (TOMS)
- JJ's Diner (JJ)
- The Pit (PIT)
- Sweetums (SWEET)
- Gryzzl (GRIZ)
- Entertainment 720 (ENT)

To use the Stock Tracker:
1. Start the backend API server: `npm run server`
2. Start the React app: `NODE_OPTIONS=--openssl-legacy-provider npm start`
3. Navigate to "Stock Tracker" in the sidebar menu
4. Add stocks to track by clicking the "+ Add" button
5. Remove stocks by clicking the "×" button

Stock prices update automatically every 5 seconds with random fluctuations.

### API Documentation

For detailed API endpoint documentation and testing examples, see:
- [API Documentation](./docs/API_DOCUMENTATION.md)

### Testing the API

You can test the API endpoints using:
- **cURL**: See examples in the API documentation
- **Postman**: Import the endpoints from the documentation
- **Test Script**: Run `node scripts/test-api.js` (requires Node.js 18+ or node-fetch)

