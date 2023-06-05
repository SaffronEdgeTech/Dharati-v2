# Use the official Node.js image as the base image
FROM node:latest

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install dependencies
RUN npm install --only=production

# Copy the Firebase backend source code to the container
COPY . .

# Expose the port for the Firebase backend server
EXPOSE 5000

# Start the Firebase backend server
CMD ["node", "index.js"]
