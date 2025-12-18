# Development Guide

This document outlines the development setup and workflow for the Realms project.

## Prerequisites

- [LÖVE2D](https://love2d.org/) 11.4 or higher
- Lua 5.1 (bundled with LÖVE2D)
- [Luacheck](https://github.com/mpeterv/luacheck) for linting
- Git

## Installing Development Tools

### Luacheck (Linter)

**Linux/macOS:**
```bash
luarocks install luacheck
```

**Windows:**
```bash
luarocks install luacheck
```

Or download from: https://github.com/mpeterv/luacheck/releases

### VS Code Setup (Optional)

1. Install the [Lua Language Server extension](https://marketplace.visualstudio.com/items?itemName=sumneko.lua)
2. Install the [LÖVE2D Support extension](https://marketplace.visualstudio.com/items?itemName=pixelbyte-studios.pixelbyte-love2d)
3. Copy `.vscode/settings.json.example` to `.vscode/settings.json`:
   ```bash
   cp .vscode/settings.json.example .vscode/settings.json
   ```

## Development Workflow

### Running the Game

```bash
make run
# or
love .
```

### Linting

Check your code for issues:

```bash
make lint
# or
luacheck .
```

### Pre-commit Hooks

To enable pre-commit hooks that automatically lint your code before commits:

**Linux/macOS:**
```bash
chmod +x .githooks/pre-commit
git config core.hooksPath .githooks
```

**Windows (Git Bash or PowerShell):**
```bash
git config core.hooksPath .githooks
```

The pre-commit hook will:
- Run luacheck on staged Lua files
- Prevent commits if linting errors are found

### Building

Create a distributable `.love` file:

```bash
make build
```

This creates `realms.love` which can be distributed or run with:
```bash
love realms.love
```

## Code Style

- **Indentation:** 4 spaces (no tabs)
- **Line length:** 120 characters max
- **File encoding:** UTF-8
- **Line endings:** LF (Unix-style)

These settings are enforced by `.editorconfig` and `.luacheckrc`.

## Continuous Integration

The project uses GitHub Actions to automatically:
- Run luacheck on all pushes and pull requests
- Ensure code quality standards are maintained

See `.github/workflows/ci.yml` for the CI configuration.

## Project Structure

```
realms/
├── .github/          # GitHub Actions workflows
├── .githooks/        # Git hooks
├── .vscode/          # VS Code settings (optional)
├── assets/           # Game assets (images, sounds, fonts)
├── libs/             # Third-party libraries
├── src/              # Game source code
├── conf.lua          # LÖVE2D configuration
├── main.lua          # Entry point
├── Makefile          # Development commands
└── README.md         # Project documentation
```

## Adding New Code

1. Write your code following the style guide
2. Run `make lint` to check for issues
3. Test your changes with `make run`
4. Commit your changes (pre-commit hook will lint automatically)

## Troubleshooting

### Luacheck not found

Make sure luacheck is installed and in your PATH:
```bash
which luacheck  # Linux/macOS
where luacheck  # Windows
```

### Pre-commit hook not running

Verify the hook is set up:
```bash
git config core.hooksPath
```

It should output `.githooks`. If not, set it:
```bash
git config core.hooksPath .githooks
```

### VS Code Lua errors

1. Ensure the Lua Language Server extension is installed
2. Copy `.vscode/settings.json.example` to `.vscode/settings.json`
3. Restart VS Code

