# PowerShell script to check if local linting setup matches CI
# Run this before pushing to catch issues early

Write-Host "Checking linting configuration..." -ForegroundColor Cyan

# Check if luacheck is installed
$luacheckPath = Get-Command luacheck -ErrorAction SilentlyContinue
if (-not $luacheckPath) {
    Write-Host "❌ ERROR: luacheck is not installed" -ForegroundColor Red
    Write-Host "   Install it with: luarocks install luacheck --local" -ForegroundColor Yellow
    Write-Host "   Or system-wide: luarocks install luacheck" -ForegroundColor Yellow
    exit 1
}

Write-Host "✓ luacheck is installed" -ForegroundColor Green

# Check if .luacheckrc exists
if (-not (Test-Path ".luacheckrc")) {
    Write-Host "❌ ERROR: .luacheckrc configuration file not found" -ForegroundColor Red
    exit 1
}

Write-Host "✓ .luacheckrc configuration file found" -ForegroundColor Green

# Run luacheck with same flags as CI
Write-Host ""
Write-Host "Running luacheck (matching CI configuration)..." -ForegroundColor Cyan
Write-Host "Command: luacheck . --no-color"
Write-Host ""

& luacheck . --no-color

$EXIT_CODE = $LASTEXITCODE

if ($EXIT_CODE -eq 0) {
    Write-Host ""
    Write-Host "✓ All checks passed! Ready to commit/push." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "❌ Linting failed. Please fix the issues above before committing." -ForegroundColor Red
    Write-Host "   Run 'make lint' to check again." -ForegroundColor Yellow
}

exit $EXIT_CODE

