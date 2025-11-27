Write-Host "`n⚠ Uninstalling PSX Profile..." -ForegroundColor Yellow
try {
    # Remove profile
    if (Test-Path $PROFILE) { Remove-Item $PROFILE -Force; Write-Host "✔ Profile removed" -ForegroundColor Green }

    # Remove logs
    $logFile = Join-Path $env:LOCALAPPDATA "PS7Logs\ps7_open_logs.json"
    if (Test-Path $logFile) { Remove-Item $logFile -Force; Write-Host "✔ Logs removed" -ForegroundColor Green }

    # Remove theme
    $themePath = "$env:LOCALAPPDATA\oh-my-posh-themes\paradox.omp.json"
    if (Test-Path $themePath) { Remove-Item $themePath -Force; Write-Host "✔ Oh My Posh theme removed" -ForegroundColor Green }

    Write-Host "✨ Uninstall complete. Restart PowerShell." -ForegroundColor Cyan
} catch {
    Write-Host "❌ Uninstall failed: $_" -ForegroundColor Red
}
