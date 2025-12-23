# GreenLake MCP Docker Setup

Docker setup scripts and configuration for GreenLake Platform MCP servers.

## Overview

This repository contains scripts to containerize the GreenLake MCP servers:
- **audit-logs** - Audit log management
- **devices** - Device inventory management  
- **subscriptions** - Subscription management
- **users** - User management
- **workspaces** - Workspace management

## Prerequisites

- Docker and Docker Compose installed
- Valid GreenLake API credentials
- The [gl-mcp](https://github.com/HewlettPackard/gl-mcp) source code

## Quick Start

### 1. Clone the gl-mcp repository

```bash
git clone https://github.com/HewlettPackard/gl-mcp.git
cd gl-mcp
```

### 2. Copy the scripts to your project

Copy the `scripts/` directory from this repository to your gl-mcp project.

### 3. Configure environment

```bash
cp .env.example .env
# Edit .env with your GreenLake credentials
```

### 4. Run the setup script

```bash
chmod +x scripts/setup-docker.sh
./scripts/setup-docker.sh
```

### 5. Build and start containers

```bash
# Run in foreground
docker-compose up --build

# Or run in detached mode
docker-compose up --build -d
```

### 6. Stop containers

```bash
docker-compose down
```

## Tool Mode: Dynamic vs Static

By default, the MCP servers are configured to use **dynamic mode** (`MCP_TOOL_MODE=dynamic`), which provides 3 meta-tools that dynamically discover and execute GreenLake API operations.

### Switching to Static Mode

If you prefer to have all tools exposed individually (static mode), you can change this in your `.env` file:

```bash
# In your .env file, change:
MCP_TOOL_MODE=static
```

**Comparison:**

| Mode | Description | Tools Exposed |
|------|-------------|---------------|
| `dynamic` (default) | Meta-tools that dynamically discover operations | 3 tools per server |
| `static` | All API operations exposed as individual tools | Many tools per server |

**Where to change:**
1. **For running containers**: Edit `.env` in your project root, then restart containers:
   ```bash
   docker-compose down && docker-compose up
   ```

2. **For new setups**: Edit `.env.example` before copying to `.env`

3. **In docker-compose.yml**: You can also override per-service:
   ```yaml
   services:
     devices:
       environment:
         MCP_TOOL_MODE: static  # Override for this service only
   ```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|----------|
| `GREENLAKE_API_BASE_URL` | GreenLake API endpoint | `https://global.api.greenlake.hpe.com` |
| `GREENLAKE_CLIENT_ID` | OAuth2 Client ID | (required) |
| `GREENLAKE_CLIENT_SECRET` | OAuth2 Client Secret | (required) |
| `GREENLAKE_WORKSPACE_ID` | Workspace ID | (required) |
| `MCP_TOOL_MODE` | Tool mode: `dynamic` or `static` | `dynamic` |
| `GREENLAKE_LOG_LEVEL` | Log level: `DEBUG`, `INFO`, `WARNING`, `ERROR` | `INFO` |
| `GREENLAKE_FILE_LOGGING` | Enable file logging | `false` |

## Scripts

| Script | Purpose |
|--------|----------|
| `setup-docker.sh` | Master script - runs all setup scripts sequentially |
| `dockerfile_script.sh` | Creates Dockerfiles for each MCP server |
| `dockerignore_script.sh` | Creates .dockerignore files |
| `docker_compose_script.sh` | Creates docker-compose.yml |
| `add_env_to_dockerignore.sh` | Adds .env to .gitignore |

## License

See the [gl-mcp](https://github.com/HewlettPackard/gl-mcp) repository for license information.
