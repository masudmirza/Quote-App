FROM node:20-alpine

# Set working directory
WORKDIR /app

# Enable Yarn (recommended for Node 20+)
RUN corepack enable && corepack prepare yarn@stable --activate

# Copy dependency definitions
COPY package.json yarn.lock ./

# Install all dependencies (including devDependencies for build)
RUN yarn install --frozen-lockfile

# Copy the full source code
COPY . .

# Set environment explicitly (optional for Docker)
ENV NODE_ENV=development

# Build the application
RUN yarn build

# Expose port if needed
EXPOSE 3000

# Run the app
CMD ["node", "dist/index.js"]
