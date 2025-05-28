# Docker Deployment Guide

This guide provides multiple ways to deploy LMStudio-MCP using Docker, depending on your needs and environment.

## Quick Start with Docker

### Option 1: Docker Run (Simplest)

```bash
# Build the image
docker build -t lmstudio-mcp .

# Run the container with host networking (required for LM Studio access)
docker run -it --network host --name lmstudio-mcp-server lmstudio-mcp
```

### Option 2: Docker Compose (Recommended)

```bash
# Start the service
docker-compose up -d

# View logs
docker-compose logs -f lmstudio-mcp

# Stop the service
docker-compose down
```

### Option 3: Pre-built Image from GitHub Container Registry

```bash
# Pull and run the pre-built image
docker run -it --network host --name lmstudio-mcp-server ghcr.io/infinitimeless/lmstudio-mcp:latest
```

## Claude MCP Configuration for Docker

### Method 1: Local Docker Container

```json
{
  "lmstudio-mcp-docker": {
    "command": "docker",
    "args": [
      "run",
      "-i",
      "--rm",
      "--network=host",
      "lmstudio-mcp"
    ]
  }
}
```

### Method 2: Docker Compose

```json
{
  "lmstudio-mcp-compose": {
    "command": "docker-compose",
    "args": [
      "-f", "/path/to/LMStudio-MCP/docker-compose.yml",
      "run",
      "--rm",
      "lmstudio-mcp"
    ]
  }
}
```

### Method 3: Pre-built Image

```json
{
  "lmstudio-mcp-ghcr": {
    "command": "docker",
    "args": [
      "run",
      "-i",
      "--rm",
      "--network=host",
      "ghcr.io/infinitimeless/lmstudio-mcp:latest"
    ]
  }
}
```

## Advanced Docker Configurations

### Custom Environment Variables

```bash
# Set custom LM Studio URL
docker run -it --network host \
  -e LMSTUDIO_API_BASE=http://127.0.0.1:1234/v1 \
  lmstudio-mcp
```

### Volume Mounting for Logs

```bash
# Mount logs directory for persistence
docker run -it --network host \
  -v $(pwd)/logs:/app/logs \
  lmstudio-mcp
```

### Running in Background

```bash
# Run as daemon with restart policy
docker run -d --restart unless-stopped \
  --network host \
  --name lmstudio-mcp-server \
  lmstudio-mcp
```

## Production Deployment

### Using Docker Swarm

```yaml
# docker-stack.yml
version: '3.8'

services:
  lmstudio-mcp:
    image: ghcr.io/infinitimeless/lmstudio-mcp:latest
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3
      placement:
        constraints:
          - node.role == manager
    networks:
      - host
    environment:
      - LMSTUDIO_API_BASE=http://localhost:1234/v1

networks:
  host:
    external: true
```

Deploy with:
```bash
docker stack deploy -c docker-stack.yml lmstudio-mcp-stack
```

### Using Kubernetes (Advanced)

```yaml
# k8s-deployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: lmstudio-mcp
  labels:
    app: lmstudio-mcp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: lmstudio-mcp
  template:
    metadata:
      labels:
        app: lmstudio-mcp
    spec:
      hostNetwork: true  # Required for LM Studio access
      containers:
      - name: lmstudio-mcp
        image: ghcr.io/infinitimeless/lmstudio-mcp:latest
        env:
        - name: LMSTUDIO_API_BASE
          value: "http://localhost:1234/v1"
        stdin: true
        tty: true
```

## Troubleshooting Docker Deployment

### Common Issues

1. **Connection refused errors**: Ensure `--network host` is used
2. **Permission denied**: Make sure Docker has proper permissions
3. **LM Studio not accessible**: Verify LM Studio is running on host

### Debugging Commands

```bash
# Check container logs
docker logs lmstudio-mcp-server

# Interactive shell in container
docker exec -it lmstudio-mcp-server bash

# Test connectivity to LM Studio from container
docker run --rm --network host curlimages/curl curl http://localhost:1234/v1/models
```

### Health Checks

```bash
# Check container health status
docker inspect lmstudio-mcp-server | grep -A 10 Health

# Manual health check
docker exec lmstudio-mcp-server python -c "import lmstudio_bridge; print('OK')"
```

## Multi-Architecture Support

The Docker image supports multiple architectures:
- `linux/amd64` (Intel/AMD 64-bit)
- `linux/arm64` (Apple Silicon, ARM64)

Build for specific architecture:
```bash
# For ARM64 (Apple Silicon)
docker buildx build --platform linux/arm64 -t lmstudio-mcp:arm64 .

# For AMD64
docker buildx build --platform linux/amd64 -t lmstudio-mcp:amd64 .

# Multi-platform build
docker buildx build --platform linux/amd64,linux/arm64 -t lmstudio-mcp:latest .
```

## Security Considerations

1. **Network isolation**: The container uses host networking by necessity
2. **Non-root user**: Container runs as non-root user `mcp`
3. **Minimal base image**: Uses Python slim image to reduce attack surface
4. **No persistent data**: Container is stateless by default

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `LMSTUDIO_API_BASE` | `http://localhost:1234/v1` | LM Studio API endpoint |
| `LOG_LEVEL` | `INFO` | Logging level |
| `TIMEOUT` | `30` | Request timeout in seconds |

## Performance Tuning

```bash
# Adjust memory limits
docker run -it --network host \
  --memory=512m \
  --memory-swap=1g \
  lmstudio-mcp

# CPU limits
docker run -it --network host \
  --cpus="0.5" \
  lmstudio-mcp
```
