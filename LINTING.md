# Linting Configuration

This document explains how to ensure your local linting setup matches the CI configuration.

## Quick Start

Run the lint check before pushing:

**Linux/macOS:**
```bash
./scripts/check-lint.sh
```

**Windows (PowerShell):**
```powershell
.\scripts\check-lint.ps1
```

**Or use Make:**
```bash
make lint
```

## Configuration Files

### `.luacheckrc`
This is the main configuration file used by both local development and CI. It defines:
- Standard globals (Lua 5.1 + LÖVE2D)
- Line length limits (120 characters)
- Files to exclude (libs, .luarocks)
- Warnings to ignore

### CI Configuration
The GitHub Actions workflow (`.github/workflows/ci.yml`) runs:
```bash
luacheck . --no-color
```

This matches the local `make lint` command.

## VS Code Integration

If you use VS Code, the `.vscode/settings.json` file configures:
- Lua language server
- Luacheck integration
- Editor settings (4 spaces, LF line endings)

The settings ensure your editor matches the project standards.

## Pre-commit Hook

The `.githooks/pre-commit` hook automatically runs luacheck on staged Lua files before each commit. This catches issues early.

To enable it:
```bash
git config core.hooksPath .githooks
```

## Ensuring Consistency

To ensure your local setup matches CI:

1. **Install luacheck:**
   ```bash
   luarocks install luacheck --local
   # Or system-wide:
   luarocks install luacheck
   ```

2. **Run the check script:**
   ```bash
   ./scripts/check-lint.sh  # Linux/macOS
   # or
   .\scripts\check-lint.ps1  # Windows
   ```

3. **Use the same command as CI:**
   ```bash
   luacheck . --no-color
   ```

4. **Enable pre-commit hook** to catch issues before committing

## Troubleshooting

### luacheck not found
- Install with: `luarocks install luacheck --local`
- Add `$HOME/.luarocks/bin` to your PATH
- Or install system-wide: `luarocks install luacheck`

### Different results locally vs CI
- Ensure you're using the same `.luacheckrc` file
- Use `--no-color` flag to match CI output
- Check luacheck version: `luacheck --version`

### Pre-commit hook not running
- Verify: `git config core.hooksPath` should output `.githooks`
- Set it: `git config core.hooksPath .githooks`
- Make sure the hook is executable: `chmod +x .githooks/pre-commit`

