# Comprehensive Deployment Options

LMStudio-MCP supports multiple deployment methods to suit different environments and preferences. This document outlines all available deployment options.

## Quick Reference

| Method | Best For | Complexity | Requirements |
|--------|----------|------------|--------------|
| **Direct Python** | Development, Testing | Low | Python 3.7+ |
| **UVX (Recommended)** | Most Users | Low | Python/Node.js |
| **Pip Install** | Python Developers | Low | Python 3.7+ |
| **Docker** | Containers, Production | Medium | Docker |
| **Docker Compose** | Local Development | Medium | Docker + Compose |
| **Kubernetes** | Enterprise, Scale | High | K8s Cluster |

## Method 1: UVX (Recommended)

UVX is the simplest way to get started:

```bash
# Install and run directly from GitHub
uvx https://github.com/infinitimeless/LMStudio-MCP

# Claude MCP Configuration
{
  "lmstudio-mcp": {
    "command": "uvx",
    "args": ["https://github.com/infinitimeless/LMStudio-MCP"]
  }
}
```

## Method 2: Direct Python Installation

For development or when you want to modify the code:

```bash
# Clone and setup
git clone https://github.com/infinitimeless/LMStudio-MCP.git
cd LMStudio-MCP
pip install -r requirements.txt

# Run
python lmstudio_bridge.py

# Claude MCP Configuration
{
  "lmstudio-mcp": {
    "command": "/bin/bash",
    "args": ["-c", "cd /path/to/LMStudio-MCP && python lmstudio_bridge.py"]
  }
}
```

## Method 3: Pip Installation

Install as a Python package:

```bash
# Install from GitHub
pip install git+https://github.com/infinitimeless/LMStudio-MCP.git

# Or install locally
pip install .

# Run
lmstudio-mcp

# Claude MCP Configuration
{
  "lmstudio-mcp": {
    "command": "lmstudio-mcp",
    "args": []
  }
}
```

## Method 4: Docker

See [DOCKER.md](DOCKER.md) for comprehensive Docker deployment guide.

### Quick Docker Start

```bash
# Build and run
docker build -t lmstudio-mcp .
docker run -it --network host lmstudio-mcp

# Or use pre-built image
docker run -it --network host ghcr.io/infinitimeless/lmstudio-mcp:latest

# Claude MCP Configuration
{
  "lmstudio-mcp-docker": {
    "command": "docker",
    "args": ["run", "-i", "--rm", "--network=host", "lmstudio-mcp"]
  }
}
```

## Method 5: Docker Compose

```bash
# Start with compose
docker-compose up -d

# View logs
docker-compose logs -f lmstudio-mcp

# Claude MCP Configuration
{
  "lmstudio-mcp-compose": {
    "command": "docker-compose",
    "args": ["run", "--rm", "lmstudio-mcp"]
  }
}
```

## Method 6: Kubernetes

For enterprise or scaled deployments:

```bash
# Apply manifests
kubectl apply -f k8s/

# Check status
kubectl get pods -l app=lmstudio-mcp
```

## Method 7: Automated Installation Script

Use the provided installation script:

```bash
# Download and run installer
curl -fsSL https://raw.githubusercontent.com/infinitimeless/LMStudio-MCP/main/install.sh | bash

# Or download first
wget https://raw.githubusercontent.com/infinitimeless/LMStudio-MCP/main/install.sh
chmod +x install.sh
./install.sh
```

The installer will:
- Detect your environment
- Install dependencies
- Set up the bridge
- Generate MCP configuration
- Provide next steps

## Environment Variables

All deployment methods support these environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `LMSTUDIO_API_BASE` | `http://localhost:1234/v1` | LM Studio API endpoint |
| `LOG_LEVEL` | `INFO` | Logging level (DEBUG, INFO, WARNING, ERROR) |
| `TIMEOUT` | `30` | Request timeout in seconds |

Example:
```bash
LMSTUDIO_API_BASE=http://127.0.0.1:1234/v1 python lmstudio_bridge.py
```

## Troubleshooting

### Common Issues

1. **Connection refused**: Ensure LM Studio is running with a model loaded
2. **404 errors**: Try using `127.0.0.1` instead of `localhost`
3. **Permission denied**: Check file permissions and Docker access
4. **Module not found**: Ensure all dependencies are installed

### Platform-Specific Notes

#### macOS
- Use `localhost` or `127.0.0.1` for LM Studio URL
- Docker Desktop may require host networking configuration

#### Windows
- Use Docker Desktop with WSL2 backend
- Path separators in configuration should use forward slashes

#### Linux
- Docker may require `sudo` or adding user to docker group
- Ensure LM Studio is accessible on the network interface

## Performance Optimization

### Resource Requirements

| Deployment | RAM | CPU | Disk |
|------------|-----|-----|------|
| Python Direct | ~50MB | Low | Minimal |
| Docker | ~100MB | Low | ~200MB |
| Kubernetes | ~150MB | Low | ~300MB |

### Optimization Tips

1. **Use lightweight base images** (already implemented in Dockerfile)
2. **Enable Docker BuildKit** for faster builds
3. **Use multi-stage builds** for smaller images
4. **Configure resource limits** in production
5. **Use persistent volumes** for logs in container environments

## Security Considerations

### Network Security
- Bridge requires access to LM Studio on localhost:1234
- Consider firewall rules for container deployments
- Use network policies in Kubernetes

### Container Security
- Runs as non-root user by default
- Minimal attack surface with slim base image
- No sensitive data stored in container

### Authentication
- No authentication required between bridge and LM Studio
- Claude MCP connection is handled by Claude's MCP framework

## Next Steps

1. Choose your preferred deployment method
2. Ensure LM Studio is running with a model loaded
3. Configure Claude MCP settings
4. Test the connection with a simple prompt
5. Explore advanced features and customization

For detailed troubleshooting, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md).
For Docker-specific guidance, see [DOCKER.md](DOCKER.md).
For contributing, see [CONTRIBUTING.md](CONTRIBUTING.md).
