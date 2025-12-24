#!/bin/bash
# (c) Copyright 2025 Hewlett Packard Enterprise Development LP
# Master script to run all security checks

set -e

echo "=============================================="
echo "🛡️  GreenLake MCP Security Checks"
echo "=============================================="
echo ""
echo "This script runs 3 security checks:"
echo "  1. Bandit     - Python code security vulnerabilities"
echo "  2. pip-audit  - Dependency vulnerability scanning"
echo "  3. Secrets    - Hardcoded secrets detection"
echo ""
echo "=============================================="

# Track failures
FAILED_CHECKS=()

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check 1: Bandit Security Analysis
echo ""
echo "🔍 [1/3] Running Bandit Security Analysis..."
echo "----------------------------------------------"
if python3 "$SCRIPT_DIR/check_bandit.py"; then
    echo "✅ Bandit check passed"
else
    echo "❌ Bandit check failed"
    FAILED_CHECKS+=("Bandit")
fi

# Check 2: pip-audit Dependency Vulnerabilities
echo ""
echo "🔍 [2/3] Running pip-audit Dependency Check..."
echo "----------------------------------------------"
if python3 "$SCRIPT_DIR/check_pip_audit.py"; then
    echo "✅ pip-audit check passed"
else
    echo "❌ pip-audit check failed"
    FAILED_CHECKS+=("pip-audit")
fi

# Check 3: Secrets Detection
echo ""
echo "🔍 [3/3] Running Secrets Detection..."
echo "----------------------------------------------"
if python3 "$SCRIPT_DIR/check_secrets.py"; then
    echo "✅ Secrets check passed"
else
    echo "❌ Secrets check failed"
    FAILED_CHECKS+=("Secrets")
fi

# Summary
echo ""
echo "=============================================="
echo "📊 Security Check Summary"
echo "=============================================="

if [ ${#FAILED_CHECKS[@]} -eq 0 ]; then
    echo "✅ All security checks passed!"
    echo ""
    exit 0
else
    echo "❌ ${#FAILED_CHECKS[@]} check(s) failed:"
    for check in "${FAILED_CHECKS[@]}"; do
        echo "   - $check"
    done
    echo ""
    echo "Please review the output above and fix any issues."
    exit 1
fi
