# Use the official Node.js 14 image for installing dependencies
FROM node:18 as deps

WORKDIR /usr/src/app

# Install dependencies using npm
COPY package.json package-lock.json ./
RUN npm install

# Use the official Bun image for building the application
FROM oven/bun:1 as builder

WORKDIR /usr/src/app

# Copy the installed dependencies from the previous stage
COPY --from=deps /usr/src/app/node_modules ./node_modules

# Copy the rest of the application code
COPY . .

# Update TLE data
RUN bun run update-tle

# Build the application
RUN bun run build

# Use the official Nginx image for serving the application
FROM nginx:stable-alpine

# Copy the built files from the builder stage to the Nginx html directory
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html

# Expose the port Nginx will listen on
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
