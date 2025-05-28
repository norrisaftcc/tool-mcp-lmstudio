# LMStudio-MCP Docker Image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better layer caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY lmstudio_bridge.py .
COPY README.md .
COPY LICENSE .

# Create non-root user for security
RUN useradd --create-home --shell /bin/bash mcp
USER mcp

# Expose the port (though MCP uses stdio by default)
EXPOSE 8000

# Health check to ensure the container is running properly
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import lmstudio_bridge; print('OK')" || exit 1

# Default command
CMD ["python", "lmstudio_bridge.py"]
