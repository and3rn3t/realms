#!/bin/bash
# Script to check if local linting setup matches CI
# Run this before pushing to catch issues early

echo "Checking linting configuration..."

# Check if luacheck is installed
if ! command -v luacheck > /dev/null 2>&1; then
    echo "❌ ERROR: luacheck is not installed"
    echo "   Install it with: luarocks install luacheck --local"
    echo "   Or system-wide: luarocks install luacheck"
    exit 1
fi

echo "✓ luacheck is installed"

# Check if .luacheckrc exists
if [ ! -f ".luacheckrc" ]; then
    echo "❌ ERROR: .luacheckrc configuration file not found"
    exit 1
fi

echo "✓ .luacheckrc configuration file found"

# Run luacheck with same flags as CI
echo ""
echo "Running luacheck (matching CI configuration)..."
echo "Command: luacheck . --no-color"
echo ""

luacheck . --no-color

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo ""
    echo "✓ All checks passed! Ready to commit/push."
else
    echo ""
    echo "❌ Linting failed. Please fix the issues above before committing."
    echo "   Run 'make lint' to check again."
fi

exit $EXIT_CODE

