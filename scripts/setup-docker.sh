#!/bin/bash
#
# gl-mcp Docker Setup Script
# ==========================
# This script sets up the Docker environment for all GreenLake MCP servers.
# It creates Dockerfiles, .dockerignore files, docker-compose.yml, and
# configures the .gitignore to protect sensitive files.
#
# Usage:
#   ./scripts/setup-docker.sh
#
# Prerequisites:
#   - Docker and Docker Compose installed
#   - Valid .env file in the project root (see .env.example)
#

set -e  # Exit on any error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "=============================================="
echo "  GreenLake MCP Docker Setup"
echo "=============================================="
echo ""

# Step 1: Create Dockerfiles for each MCP server
echo "📦 Step 1/5: Creating Dockerfiles..."
bash "$SCRIPT_DIR/dockerfile_script.sh"
echo ""

# Step 2: Create .dockerignore files
echo "🚫 Step 2/5: Creating .dockerignore files..."
bash "$SCRIPT_DIR/dockerignore_script.sh"
echo ""

# Step 3: Add .env to .gitignore
echo "🔒 Step 3/5: Securing .env in .gitignore..."
bash "$SCRIPT_DIR/add_env_to_gitignore.sh"
echo ""

# Step 4: Create docker-compose.yml
echo "🐳 Step 4/5: Creating docker-compose.yml..."
bash "$SCRIPT_DIR/docker_compose_script.sh"
echo ""

# Step 5: Verify .env file exists
echo "🔑 Step 5/5: Checking environment configuration..."
if [ -f "$PROJECT_ROOT/.env" ]; then
    echo "✓ .env file found"
else
    echo "⚠️  WARNING: No .env file found in project root!"
    echo ""
    echo "   Create a .env file with the following variables:"
    echo "   ------------------------------------------------"
    echo "   GREENLAKE_CLIENT_ID=your_client_id"
    echo "   GREENLAKE_CLIENT_SECRET=your_client_secret"
    echo "   GREENLAKE_WORKSPACE_ID=your_workspace_id"
    echo ""
    echo "   You can copy .env.example as a template:"
    echo "   cp .env.example .env"
    echo ""
fi

echo ""
echo "=============================================="
echo "  ✅ Setup Complete!"
echo "=============================================="
echo ""
echo "Next steps:"
echo "  1. Ensure your .env file is configured with valid GreenLake credentials"
echo "  2. Build and start the containers:"
echo "     docker-compose up --build"
echo ""
echo "  Or run in detached mode:"
echo "     docker-compose up --build -d"
echo ""
echo "  To stop the containers:"
echo "     docker-compose down"
echo ""
