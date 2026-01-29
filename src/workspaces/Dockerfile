# syntax=docker/dockerfile:1
# Multi-stage optimized Dockerfile for GreenLake MCP Workspaces Server

# =============================================================================
# Stage 1: Dependencies (cached layer)
# =============================================================================
FROM python:3.11-slim-bookworm AS deps

# Install uv package manager (pinned version for reproducibility)
RUN pip install --no-cache-dir uv==0.5.14

WORKDIR /app

# Copy only dependency files first (for layer caching)
COPY pyproject.toml uv.lock ./

# Install dependencies with cache mount for faster rebuilds
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev

# =============================================================================
# Stage 2: Runtime (minimal production image)
# =============================================================================
FROM python:3.11-slim-bookworm AS runtime

# OCI Image Labels
LABEL org.opencontainers.image.title="GreenLake MCP Workspaces Server"
LABEL org.opencontainers.image.description="HPE GreenLake workspaces MCP Server"
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

# Install uv in runtime (needed to run the app)
RUN pip install --no-cache-dir uv==0.5.14

WORKDIR /app

# Copy installed dependencies from deps stage
COPY --from=deps /app/.venv /app/.venv

# Copy application code
COPY --chown=mcpuser:mcpuser . .

# Switch to non-root user
USER mcpuser

# Health check - verify server module can be imported
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "from server import mcp_server; print('healthy')" || exit 1

CMD ["uv", "run", "python", "__main__.py"]
