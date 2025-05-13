# Stage 1: Build environment
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci

# Copy all project files and build
COPY . .
RUN npm run build

# Stage 2: Production environment
FROM node:18-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

# Copy built files from builder stage
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]