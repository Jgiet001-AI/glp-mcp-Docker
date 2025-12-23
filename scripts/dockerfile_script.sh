for server in audit-logs devices subscriptions users workspaces; do
    cat > src/$server/Dockerfile <<'EOF'
FROM python:3.11-slim

WORKDIR /app

# Install uv package manager
RUN pip install --no-cache-dir uv

# Copy project files
COPY . .

# Install dependencies using uv
RUN uv sync --frozen

ENV GREENLAKE_API_BASE_URL=""
ENV GREENLAKE_CLIENT_ID=""
ENV GREENLAKE_CLIENT_SECRET=""
ENV GREENLAKE_WORKSPACE_ID=""
ENV MCP_TOOL_MODE="dynamic"
ENV GREENLAKE_LOG_LEVEL="INFO"
ENV GREENLAKE_FILE_LOGGING="false"

CMD ["uv", "run", "python", "__main__.py"]
EOF
    echo "Done creating Dockerfile for src/$server/"
done
