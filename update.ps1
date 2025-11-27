Write-Host "`n🔄 Updating PSX Profile..." -ForegroundColor Cyan
try {
    $profileUrl = "https://raw.githubusercontent.com/Mahmoud-walid/psx-profile/main/Microsoft.PowerShell_profile.ps1"
    Invoke-WebRequest -Uri $profileUrl -OutFile $PROFILE -UseBasicParsing
    . $PROFILE
    Write-Host "✔ PSX Profile updated successfully!" -ForegroundColor Green
} catch {
    Write-Host "❌ Update failed: $_" -ForegroundColor Red
}
