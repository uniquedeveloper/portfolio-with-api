# Setup Instructions for Dockerized Project with Docker Compose

This guide will help setting up and run the project using **Docker Compose**, which manages multiple services, such as a **cache server** and an **API server**.

## Project Setup

### 1. **Clone the Repository**

# Clone the repository, navigate to the project folder, copy the example environment file, and install dependencies


```bash
git clone https://github.com/uniquedeveloper/portfolio-with-api.git
cd portfolio-with-api
cp .env.example .env
npm install
```

### 2. **Build and Run Containers with Docker Compose**

To build and start all services (e.g., cache and API servers) at once using Makefile:

```bash
make up
```

Alternatively, run the same Docker Compose command directly without using the Makefile:

```bash
docker compose up --build
```

This will:

- Build the images as defined in the `Dockerfile`.
- Start the `cache-server` and `api-server` containers.
- Set up networking and inter-service dependencies.

After the command runs successfully, the services will start, and see logs from the containers.

#### Running in Detached Mode

To run containers in the background using Makefile:

```bash
make up-detached
```

Alternatively, run the same command directly:

```bash
docker compose up -d --build
```

This will start the containers in detached mode, and view logs or stop the containers later.

### 3. **Access the Services**

Once the containers are running:

- **Cache Server**: Accessible at `http://localhost:3000`.
- **API Server**: Accessible at `http://localhost:8080`.

### 4. **Viewing Logs**

To view logs from the running containers using Makefile:

- For **cache server** logs:
   ```bash
   make logs-cache
   ```

- For **API server** logs:
   ```bash
   make logs-api
   ```

Alternatively, directly use Docker Compose to view the logs:

- For **cache server** logs:
   ```bash
   docker compose logs -f portfolio-cache-server
   ```

- For **API server** logs:
   ```bash
   docker compose logs -f portfolio-api
   ```

Press `Ctrl + C` to stop viewing logs.

### 5. **Stopping the Containers**

To stop the containers using Makefile:

```bash
make down
```

Alternatively, run the same command directly:

```bash
docker compose down
```

This will stop and remove the containers. If you just want to stop them without removing, use:

```bash
docker compose stop
```

### 6. **Removing Containers and Networks**

To remove the containers, networks, and volumes using Makefile:

```bash
make clean
```

Alternatively, run the same command directly:

```bash
docker compose down --volumes --remove-orphans
```

---

## Dockerfile Breakdown

### **Multi-Stage Build**

The Dockerfile uses **multi-stage builds** for optimization, ensuring only necessary files and dependencies are included in the final image.

1. **Builder Stage**:
   - Installs required build tools and dependencies.
   - Uses `npm ci` to install production dependencies and `npm i --no-save` to install TypeScript and related packages.

2. **Cache Server Stage**:
   - Runs the cache server.
   - Copies necessary files from the builder stage and starts the server.

3. **API Server Stage**:
   - Runs the API server in a similar way as the cache server.

### **Health Checks**

Health checks ensure the containers are functioning correctly:

- **Cache Server**:
  ```yaml
  healthcheck:
    test: ["CMD", "curl", "-f", "http://localhost:3000"]
    interval: 30s
    timeout: 5s
    retries: 2
    start_period: 30s
  ```

- **API Server**:
  ```yaml
  healthcheck:
    test: ["CMD", "curl", "-f", "http://localhost:8080/v1/health"]
    interval: 30s
    timeout: 5s
    retries: 2
    start_period: 30s
  ```

These checks help ensure the services are healthy and restart them if needed.

### **Why Use Docker Compose?**

- **Easy Service Management**: Manage both the cache server and API server as services.
- **Service Dependencies**: The API server depends on the cache server, so Docker Compose ensures the cache server is healthy before starting the API server.
- **Networking**: Both services are on the same network, allowing them to communicate easily.
- **Health Checks**: Docker Compose monitors the health of the services and restarts them if necessary.

---

## Troubleshooting

If having issues, try these solutions:

- **Missing dependencies**: Run `npm install` to make sure all dependencies are installed.
- **Containers not starting**: Check the logs with `docker compose logs` to diagnose the issue.
- **Network issues**: Ensure the containers are on the correct network as defined in the `docker compose.yml` file.

