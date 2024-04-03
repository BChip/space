# Use the official Node.js 14 as a parent image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to workdir
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of your application's source code
COPY . .

# Build your application
RUN npm run build

# Expose the port your app runs on
EXPOSE 8080

RUN npm run update-tle

# Command to run your app using npm
CMD ["npm", "run", "serve"]
