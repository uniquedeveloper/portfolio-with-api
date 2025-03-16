# Alpine is a great choice for the base image because it's lightweight (around 5MB), 
# which reduces image size, speeds up build times, and makes deployments faster, 
# especially in CI/CD pipelines. It also offers better security and has less vulnerabilities 
# compared to other distributions like Debian or Ubuntu. 
# Despite being minimal, Alpine still allows to install necessary dependencies, 
# making it flexible for custom applications. As for using `node:23-alpine` over `node:18-alpine`,
#  Node 23 brings the latest features, optimizations, and performance improvements, making it a 
# better choice for newer projects. It also ensures better long-term support with security patches, 
# while Node 18, although stable, is an older LTS release and may receive fewer updates going forward.

# Builder Stage - install dependencies and build the project
FROM node:23-alpine AS builder

WORKDIR /app

# Copy package files first to leverage Docker cache more effectively
COPY package*.json ./
COPY nx.json ./
COPY packages/plugins/package.json ./packages/plugins/
COPY packages/core/package.json ./packages/core/
# Install build dependencies and production dependencies
RUN apk add --no-cache \
    python3 \
    make gcc g++ linux-headers udev \
    pkgconfig libusb-dev eudev-dev libtool autoconf automake \
  && npm ci --production \
  && npm i --no-save ts-node typescript @types/node

# Copy the rest of the application files
COPY packages ./packages
COPY typedoc*.json ./
COPY tsconfig*.json ./
COPY project.json ./
COPY migrations.json ./

# Cache Server Stage - cache server specific setup
FROM node:23-alpine AS cache

WORKDIR /app

COPY packages ./packages
COPY typedoc*.json ./
COPY tsconfig*.json ./
COPY project.json ./
COPY migrations.json ./

# Install curl for health checks
RUN apk add --no-cache curl

# Start cache server
CMD ["npx", "ts-node", "-P", "packages/plugins/tsconfig.script.json", "packages/plugins/scripts/serve-cache.ts"]

# API Stage - api specific setup
FROM node:23-alpine AS api

WORKDIR /app

# Copy the required files from the cache stage
COPY --from=cache /app/packages/core ./packages/core
COPY --from=cache /app/packages/plugins ./packages/plugins
COPY --from=cache /app/packages/api ./packages/api

COPY --from=cache /app/*.json ./

# Install curl for health checks
RUN apk add --no-cache curl

# Start API server
CMD ["npx", "ts-node", "-P", "packages/api/tsconfig.json", "packages/api/src/main.ts"]
