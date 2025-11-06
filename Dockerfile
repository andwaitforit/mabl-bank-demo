# Multi-stage build for React frontend
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build argument for API URL
ARG REACT_APP_API_URL=http://localhost:3001/api
ENV REACT_APP_API_URL=$REACT_APP_API_URL

# Override homepage for Docker deployment (remove GitHub Pages path)
# Temporarily remove homepage from package.json so assets are served from root
RUN node -e "const pkg = require('./package.json'); delete pkg.homepage; require('fs').writeFileSync('package.json', JSON.stringify(pkg, null, 2));"

ENV NODE_OPTIONS=--openssl-legacy-provider

# Build the React app
RUN npm run build

# Production stage with nginx
FROM nginx:alpine

# Copy built files from builder
COPY --from=builder /app/build /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]


