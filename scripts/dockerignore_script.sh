for server in audit-logs devices subscriptions users workspaces; do
  cat > src/$server/.dockerignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python

# Distribution / packaging
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Testing
.pytest_cache/
.coverage
htmlcov/
.tox/
tests/

# Environment
.env
.env.local
.venv
venv/
ENV/

# IDE
.vscode/
.idea/
*.swp
*.swo

# Documentation
*.md
!README.md

# Git
.git/
.gitignore

# Build tools
Makefile

# Logs
*.log
EOF
  echo "✓ Created .dockerignore in src/$server/"
done
