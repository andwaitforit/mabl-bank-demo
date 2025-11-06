# Docker Testing Guide

This guide will help you test the Docker containerization of the banking app.

## Prerequisites

1. **Docker installed**: Verify with `docker --version`
2. **Docker Compose installed**: Verify with `docker-compose --version`
3. **Ports available**: Ensure ports 3000 and 3001 are not in use

## Quick Test

### 1. Build and Start Containers

```bash
# Build and start all services
docker-compose up --build
```

This will:
- Build the frontend container (React app)
- Build the API container (Node.js server)
- Start both services
- Show logs from both containers

### 2. Verify Services are Running

In a new terminal, check running containers:
```bash
docker-compose ps
```

You should see both `frontend` and `api` services running.

### 3. Test the API

Test the backend API directly:
```bash
# Test from your host machine
curl http://localhost:3001/api/stocks

# Or test a specific stock
curl http://localhost:3001/api/stocks/SWANSON
```

Expected response: JSON array of stocks or a single stock object.

### 4. Test the Frontend

1. Open your browser and navigate to: **http://localhost:3000**
2. You should see the login page
3. Try logging in with:
   - Username: `admin`
   - Password: `admin`

### 5. Test Stock Tracker Feature

1. After logging in, click "Stock Tracker" in the sidebar
2. Verify that stocks are loading from the API
3. Try adding a stock by clicking "+ Add"
4. Verify the stock appears in the "Tracked Stocks" section
5. Check that prices update (they refresh every 5 seconds)

## Detailed Testing Steps

### Test 1: Container Build

```bash
# Clean start - remove any existing containers
docker-compose down

# Build without cache to ensure fresh build
docker-compose build --no-cache

# Check that images were created
docker images | grep banking-app
```

### Test 2: Individual Container Testing

**Test API container only:**
```bash
# Build API container
docker build -f Dockerfile.api -t banking-app-api .

# Run API container
docker run -d -p 3001:3001 --name test-api banking-app-api

# Test API
curl http://localhost:3001/api/stocks

# Stop and remove
docker stop test-api
docker rm test-api
```

**Test Frontend container only:**
```bash
# Build frontend container
docker build -t banking-app-frontend .

# Run frontend container
docker run -d -p 3000:80 --name test-frontend banking-app-frontend

# Open browser to http://localhost:3000
# Verify login page loads

# Stop and remove
docker stop test-frontend
docker rm test-frontend
```

### Test 3: Full Integration Test

1. **Start all services:**
   ```bash
   docker-compose up -d
   ```

2. **Check logs:**
   ```bash
   # View all logs
   docker-compose logs
   
   # View frontend logs only
   docker-compose logs frontend
   
   # View API logs only
   docker-compose logs api
   
   # Follow logs in real-time
   docker-compose logs -f
   ```

3. **Test API endpoints:**
   ```bash
   # Get all stocks
   curl http://localhost:3001/api/stocks | jq
   
   # Get single stock
   curl http://localhost:3001/api/stocks/SWANSON | jq
   
   # Get multiple stocks
   curl http://localhost:3001/api/stocks/batch/SWANSON,LITTLES,PAWN | jq
   ```

4. **Test frontend functionality:**
   - Login with admin credentials
   - Navigate to different pages
   - Test account creation
   - Test deposits/withdrawals
   - Test fund transfers
   - Test Stock Tracker (add/remove stocks)

### Test 4: Network Connectivity

Verify containers can communicate:
```bash
# Execute command in frontend container
docker-compose exec frontend ping -c 3 api

# Check if frontend can reach API (from inside container)
docker-compose exec frontend wget -O- http://api:3001/api/stocks
```

### Test 5: Environment Variables

Test with custom API URL:
```bash
# Stop current containers
docker-compose down

# Build with custom API URL
docker-compose build --build-arg REACT_APP_API_URL=http://custom-api:3001/api frontend

# Start services
docker-compose up -d
```

## Troubleshooting

### Issue: Containers won't start

**Check logs:**
```bash
docker-compose logs
```

**Common issues:**
- Port already in use: `Error: bind: address already in use`
  - Solution: Stop the service using the port or change ports in docker-compose.yml
- Build fails: Check Dockerfile syntax and dependencies

### Issue: Frontend can't connect to API

**Check:**
1. Both containers are running: `docker-compose ps`
2. API is accessible: `curl http://localhost:3001/api/stocks`
3. Browser console for CORS errors
4. Network configuration in docker-compose.yml

**Solution:**
- Verify API URL in browser's Network tab
- Check that API container is exposing port 3001
- Verify CORS is enabled in server.js

### Issue: Stock Tracker shows errors

**Check browser console:**
- Open Developer Tools (F12)
- Check Console tab for errors
- Check Network tab for failed API requests

**Verify:**
- API container is running
- API is accessible at http://localhost:3001
- No CORS errors in console

### Issue: Changes not reflecting

**Rebuild containers:**
```bash
docker-compose down
docker-compose up --build
```

### Issue: Container keeps restarting

**Check logs:**
```bash
docker-compose logs [service-name]
```

**Common causes:**
- Application crash
- Port conflicts
- Missing dependencies

## Performance Testing

### Check Resource Usage

```bash
# View resource usage
docker stats

# View specific container
docker stats banking-app-frontend-1
docker stats banking-app-api-1
```

### Load Testing

```bash
# Test API with multiple requests
for i in {1..10}; do
  curl http://localhost:3001/api/stocks &
done
wait
```

## Cleanup

### Stop and Remove Containers

```bash
# Stop containers
docker-compose down

# Stop and remove volumes
docker-compose down -v

# Remove images
docker-compose down --rmi all
```

### Complete Cleanup

```bash
# Remove all containers, networks, and images
docker-compose down -v --rmi all

# Remove any dangling images
docker image prune -a
```

## Automated Testing Script

Create a test script to automate testing:

```bash
#!/bin/bash
# test-docker.sh

echo "Building containers..."
docker-compose build

echo "Starting containers..."
docker-compose up -d

echo "Waiting for services to start..."
sleep 5

echo "Testing API..."
API_RESPONSE=$(curl -s http://localhost:3001/api/stocks)
if [ -z "$API_RESPONSE" ]; then
  echo "❌ API test failed"
  exit 1
else
  echo "✅ API test passed"
fi

echo "Testing Frontend..."
FRONTEND_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000)
if [ "$FRONTEND_RESPONSE" != "200" ]; then
  echo "❌ Frontend test failed (HTTP $FRONTEND_RESPONSE)"
  exit 1
else
  echo "✅ Frontend test passed"
fi

echo "All tests passed!"
docker-compose logs --tail=20
```

Make it executable:
```bash
chmod +x test-docker.sh
./test-docker.sh
```

## Verification Checklist

- [ ] Containers build successfully
- [ ] Both containers start without errors
- [ ] API responds at http://localhost:3001/api/stocks
- [ ] Frontend loads at http://localhost:3000
- [ ] Login page displays correctly
- [ ] Can log in with admin credentials
- [ ] Stock Tracker page loads
- [ ] Stocks are fetched from API
- [ ] Can add stocks to tracker
- [ ] Can remove stocks from tracker
- [ ] Stock prices update automatically
- [ ] No console errors in browser
- [ ] No CORS errors
- [ ] All other app features work (deposits, withdrawals, transfers)

## Next Steps

After successful testing:
1. Tag the Docker images for versioning
2. Push to a container registry (Docker Hub, AWS ECR, etc.)
3. Deploy to your hosting environment
4. Set up CI/CD pipeline for automated builds


