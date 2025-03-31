# --- Builder Stage ---
FROM node:18 as builder
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json .
RUN npm install

# Copy the rest of the app code
COPY . .

# --- Production Stage ---
FROM node:18-slim # Use a smaller Node.js base image
WORKDIR /app

# Copy necessary files from the builder stage
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/public ./public
COPY --from=builder /app/src ./src
COPY --from=builder /app/index.js ./
COPY --from=builder /app/server.js ./ # Or your entry point

# Expose the port
EXPOSE 8082

# Start the application
CMD ["npm", "start"]
