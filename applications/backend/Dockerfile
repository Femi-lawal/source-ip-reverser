# Use the official Node.js 16 (LTS) image as the base image
FROM node:16-slim

# Set the working directory in the Docker container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json for dependency installation
COPY package*.json ./

# Install dependencies (production only)
RUN npm install --only=production

# Copy the rest of your application code
COPY index.js ./

# Set a non-root user and switch to it for security reasons
RUN chown -R node:node /usr/src/app
USER node

# Expose the port your app runs on
EXPOSE 3000

# Command to run your app
CMD ["node", "index.js"]
