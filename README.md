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

## Quick Start

### 1. Clone this repository

```bash
git clone https://github.com/Jgiet001-AI/glp-mcp-Docker.git
cd glp-mcp-Docker
```

### 2. Configure environment

```bash
cp .env.example .env
# Edit .env with your GreenLake credentials
```

### 3. Run the setup script

```bash
chmod +x scripts/setup-docker.sh
./scripts/setup-docker.sh
```

### 4. Build and start containers

```bash
# Run in foreground
docker-compose up --build

# Or run in detached mode
docker-compose up --build -d
```

### 5. Stop containers

```bash
docker-compose down
```

## Claude Desktop MCP Configuration

To connect Claude Desktop to the running Docker containers, add this to your Claude Desktop config file:

**Config location:**
- macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
- Windows: `%APPDATA%\Claude\claude_desktop_config.json`

### Finding Your Docker Path

> ⚠️ **Important:** Claude Desktop may not find `docker` in its PATH. You must use the **full path** to the docker executable.

Run this command to find your docker path:
```bash
which docker
```

Common locations:
- **Docker Desktop (macOS):** `/Users/<username>/.docker/bin/docker`
- **Homebrew:** `/opt/homebrew/bin/docker` or `/usr/local/bin/docker`
- **Linux:** `/usr/bin/docker`

### Sample Configuration

Replace `/path/to/docker` with your actual docker path from the command above:

```json
{
  "mcpServers": {
    "greenlake-audit-logs": {
      "command": "/path/to/docker",
      "args": ["exec", "-i", "mcp-audit-logs", "uv", "run", "python", "__main__.py"]
    },
    "greenlake-devices": {
      "command": "/path/to/docker",
      "args": ["exec", "-i", "mcp-devices", "uv", "run", "python", "__main__.py"]
    },
    "greenlake-subscriptions": {
      "command": "/path/to/docker",
      "args": ["exec", "-i", "mcp-subscriptions", "uv", "run", "python", "__main__.py"]
    },
    "greenlake-users": {
      "command": "/path/to/docker",
      "args": ["exec", "-i", "mcp-users", "uv", "run", "python", "__main__.py"]
    },
    "greenlake-workspaces": {
      "command": "/path/to/docker",
      "args": ["exec", "-i", "mcp-workspaces", "uv", "run", "python", "__main__.py"]
    }
  }
}
```

### Example with Docker Desktop on macOS

If your docker is at `/Users/johndoe/.docker/bin/docker`:

```json
{
  "mcpServers": {
    "greenlake-audit-logs": {
      "command": "/Users/johndoe/.docker/bin/docker",
      "args": ["exec", "-i", "mcp-audit-logs", "uv", "run", "python", "__main__.py"]
    },
    "greenlake-devices": {
      "command": "/Users/johndoe/.docker/bin/docker",
      "args": ["exec", "-i", "mcp-devices", "uv", "run", "python", "__main__.py"]
    }
  }
}
```

### Troubleshooting: "No such file or directory"

If you see this error in Claude logs (`~/Library/Logs/Claude/mcp-server-*.log`):

```
Failed to spawn process: No such file or directory
```

This means Claude can't find the `docker` command. Fix by:
1. Run `which docker` to get the full path
2. Update your config to use the full path instead of just `docker`

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
| `add_env_to_gitignore.sh` | Adds .env to .gitignore to protect credentials |

## Acknowledgments

This project is based on [gl-mcp](https://github.com/HewlettPackard/gl-mcp) by Hewlett Packard Enterprise, licensed under the MIT License.

## License

MIT License
