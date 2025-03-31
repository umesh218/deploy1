# Use official Node.js image
FROM node:18

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json .
RUN npm install

# Copy the app code
COPY . .

# Expose the port
EXPOSE 8082

# Start the application
CMD ["npm", "start"]
