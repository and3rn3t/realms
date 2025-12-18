#!/bin/bash
# Setup script for Realms development environment

set -e

echo "Setting up Realms development environment..."
echo ""

# Check if luacheck is installed
if ! command -v luacheck &> /dev/null; then
    echo "⚠️  Luacheck not found. Installing..."
    if command -v luarocks &> /dev/null; then
        luarocks install luacheck
    else
        echo "❌ Luarocks not found. Please install luacheck manually:"
        echo "   luarocks install luacheck"
        echo "   Or visit: https://github.com/mpeterv/luacheck"
    fi
else
    echo "✅ Luacheck is installed"
fi

# Setup pre-commit hooks
echo ""
echo "Setting up Git hooks..."
if [ -d ".git" ]; then
    chmod +x .githooks/pre-commit
    git config core.hooksPath .githooks
    echo "✅ Pre-commit hooks configured"
else
    echo "⚠️  Not a Git repository. Skipping Git hooks setup."
fi

# Setup VS Code settings (if VS Code is available)
if [ -d ".vscode" ] && [ ! -f ".vscode/settings.json" ]; then
    if command -v code &> /dev/null || [ -n "$VSCODE" ]; then
        echo ""
        echo "Setting up VS Code..."
        cp .vscode/settings.json.example .vscode/settings.json
        echo "✅ VS Code settings configured"
    fi
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "  - Run 'make run' to start the game"
echo "  - Run 'make lint' to check code quality"
echo "  - See DEVELOPMENT.md for more information"

