# Use latest patched Python slim image
FROM python:3.11-slim-bookworm

# OCI Image Labels
LABEL org.opencontainers.image.title="GreenLake MCP Subscriptions Server"
LABEL org.opencontainers.image.description="HPE GreenLake subscriptions MCP Server"
LABEL org.opencontainers.image.vendor="HPE GreenLake Platform Team"
LABEL org.opencontainers.image.source="https://github.com/Jgiet001-AI/glp-mcp-Docker"
LABEL org.opencontainers.image.licenses="Apache-2.0"

# Update system packages to fix vulnerabilities
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user for security
RUN groupadd --gid 1000 mcpuser && \
    useradd --uid 1000 --gid 1000 --create-home mcpuser

WORKDIR /app

# Install uv package manager (pinned version for reproducibility)
RUN pip install --no-cache-dir uv==0.5.14

# Copy application code
COPY --chown=mcpuser:mcpuser . .

# Install dependencies as root (needs write to cache), then switch
RUN uv sync --frozen --no-dev

# Switch to non-root user
USER mcpuser

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import sys; sys.exit(0)" || exit 1

CMD ["uv", "run", "python", "__main__.py"]
