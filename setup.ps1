# Setup script for Realms development environment (PowerShell)

Write-Host "Setting up Realms development environment..." -ForegroundColor Cyan
Write-Host ""

# Check if luacheck is installed
$luacheckInstalled = $false
try {
    $null = Get-Command luacheck -ErrorAction Stop
    $luacheckInstalled = $true
} catch {
    $luacheckInstalled = $false
}

if (-not $luacheckInstalled) {
    Write-Host "⚠️  Luacheck not found. Installing..." -ForegroundColor Yellow
    try {
        $null = Get-Command luarocks -ErrorAction Stop
        luarocks install luacheck
        Write-Host "✅ Luacheck installed" -ForegroundColor Green
    } catch {
        Write-Host "❌ Luarocks not found. Please install luacheck manually:" -ForegroundColor Red
        Write-Host "   luarocks install luacheck" -ForegroundColor Yellow
        Write-Host "   Or visit: https://github.com/mpeterv/luacheck" -ForegroundColor Yellow
    }
} else {
    Write-Host "✅ Luacheck is installed" -ForegroundColor Green
}

# Setup pre-commit hooks
Write-Host ""
Write-Host "Setting up Git hooks..." -ForegroundColor Cyan
if (Test-Path ".git") {
    try {
        git config core.hooksPath .githooks
        Write-Host "✅ Pre-commit hooks configured" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  Could not configure Git hooks" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠️  Not a Git repository. Skipping Git hooks setup." -ForegroundColor Yellow
}

# Setup VS Code settings (if VS Code is available)
if ((Test-Path ".vscode") -and -not (Test-Path ".vscode/settings.json")) {
    try {
        $null = Get-Command code -ErrorAction Stop
        Copy-Item ".vscode/settings.json.example" ".vscode/settings.json"
        Write-Host "✅ VS Code settings configured" -ForegroundColor Green
    } catch {
        # VS Code not in PATH, but that's okay
    }
}

Write-Host ""
Write-Host "✅ Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  - Run 'make run' to start the game"
Write-Host "  - Run 'make lint' to check code quality"
Write-Host "  - See DEVELOPMENT.md for more information"

