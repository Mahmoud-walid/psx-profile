# ================================
#      PSX-PROFILE INSTALLER
# ================================

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "For best results (installing fonts/winget), run as Administrator."
}

Write-Host "`n🚀 Starting PSX Profile Installation..." -ForegroundColor Cyan

# Define Correct Profile Path for PowerShell 7
$TargetProfile = $PROFILE.CurrentUserAllHosts
if (-not $TargetProfile) { 
    # Fallback if variable is empty
    $TargetProfile = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "PowerShell\Microsoft.PowerShell_profile.ps1"
}

# 1. Create Directory
$profileDir = Split-Path $TargetProfile
if (-not (Test-Path $profileDir)) { New-Item -ItemType Directory -Force -Path $profileDir | Out-Null }

# 2. Install Oh My Posh
if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Write-Host "➡ Installing Oh My Posh..." -ForegroundColor Yellow
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install JanDeDobbeleer.OhMyPosh -s winget --accept-package-agreements --accept-source-agreements
    } else {
        # Fallback installation method
        Set-ExecutionPolicy Bypass -Scope Process -Force
        Invoke-Expression (Invoke-RestMethod -Uri 'https://ohmyposh.dev/install.ps1')
    }
}

# 3. Download Theme
$themeDir = "$env:LOCALAPPDATA\oh-my-posh-themes"
if (-not (Test-Path $themeDir)) { New-Item -ItemType Directory -Force -Path $themeDir | Out-Null }
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/paradox.omp.json" -OutFile "$themeDir\paradox.omp.json" -UseBasicParsing

# 4. Install Profile
Write-Host "➡ Downloading Profile Script to: $TargetProfile" -ForegroundColor Yellow
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Mahmoud-walid/psx-profile/main/Microsoft.PowerShell_profile.ps1" -OutFile $TargetProfile -UseBasicParsing

Write-Host "`n🎉 Installation Complete!" -ForegroundColor Green
Write-Host "👉 Please restart your terminal or run: . `"$TargetProfile`"" -ForegroundColor Cyan