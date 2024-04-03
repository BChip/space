# Use the official Bun image for building the application
FROM oven/bun:1 as builder

WORKDIR /usr/src/app

# Install dependencies
COPY package.json bun.lockb ./
RUN npm install

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
