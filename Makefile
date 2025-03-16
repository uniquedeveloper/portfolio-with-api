# Makefile for managing Dockerized TypeScript project

# Define variables for the services
CACHE_SERVICE=portfolio-cache-server
API_SERVICE=portfolio-api

# Define the Docker Compose command
DOCKER_COMPOSE=docker compose

# Define the default branch (can be overridden by setting BRANCH)
BRANCH ?= main

# Default target
.PHONY: all
all: help

# Build and start the containers
.PHONY: up
up:
	$(DOCKER_COMPOSE) up --build

# Run containers in detached mode (in the background)
.PHONY: up-detached
up-detached:
	$(DOCKER_COMPOSE) up -d --build

# Stop the running containers
.PHONY: down
down:
	$(DOCKER_COMPOSE) down

# Stop the containers without removing them
.PHONY: stop
stop:
	$(DOCKER_COMPOSE) stop

# View the logs of the cache server
.PHONY: logs-cache
logs-cache:
	$(DOCKER_COMPOSE) logs -f $(CACHE_SERVICE)

# View the logs of the API server
.PHONY: logs-api
logs-api:
	$(DOCKER_COMPOSE) logs -f $(API_SERVICE)

# Remove containers, networks, and volumes
.PHONY: clean
clean:
	$(DOCKER_COMPOSE) down --volumes --remove-orphans

# Reset the environment (down, prune, pull latest, rebuild)
.PHONY: reset
reset: down prune up

# Prune unused Docker data (containers, networks, images, volumes)
.PHONY: prune
prune:
	@echo "Pruning unused Docker data..."
	docker system prune -af

# Pull the latest code from the default branch
.PHONY: pull-repo
pull-repo:
	@echo "Pulling the latest code from branch $(BRANCH)..."
	git fetch origin
	git checkout $(BRANCH)
	git pull origin $(BRANCH)

# Show help message
.PHONY: help
help:
	@echo "Makefile for Dockerized TypeScript Project"
	@echo ""
	@echo "Usage:"
	@echo "  make up               Build and start the containers"
	@echo "  make up-detached      Build and start the containers in detached mode"
	@echo "  make down             Stop and remove containers"
	@echo "  make stop             Stop containers without removing them"
	@echo "  make logs-cache       View logs of the cache server"
	@echo "  make logs-api         View logs of the API server"
	@echo "  make clean            Remove containers, networks, and volumes"
	@echo "  make reset            Reset the environment: down, prune, pull latest, and rebuild containers"
	@echo "  make help             Show this help message"
