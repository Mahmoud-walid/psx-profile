# ================================
#      PSX-PROFILE INSTALLER
# ================================

Write-Host "`n🚀 Starting PSX Profile Installation..." -ForegroundColor Cyan

function Invoke-Safe {
    param(
        [Parameter(Mandatory)][string]$Message,
        [Parameter(Mandatory)][scriptblock]$Action
    )

    Write-Host "➡ $Message" -ForegroundColor Yellow
    try {
        & $Action
        Write-Host "✔ Done: $Message" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ ERROR during: $Message" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor DarkRed
        exit 1
    }
}

# ------------------------------
# 1️⃣ Ensure PS profile folder exists
# ------------------------------
Invoke-Safe -Message "Ensuring profile directory exists" -Action {
    $profileDir = Split-Path $PROFILE
    if (-not (Test-Path $profileDir)) {
        New-Item -ItemType Directory -Force -Path $profileDir | Out-Null
    }
}

# ------------------------------
# 2️⃣ Install Oh My Posh if missing
# ------------------------------
if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Invoke-Safe -Message "Installing Oh My Posh via winget" -Action {
        winget install JanDeDobbeleer.OhMyPosh -s winget --accept-package-agreements --accept-source-agreements
    }
}
else {
    Write-Host "✔ Oh My Posh already installed." -ForegroundColor Green
}

# ------------------------------
# 3️⃣ Download official Oh My Posh theme
# ------------------------------
Invoke-Safe -Message "Downloading Paradox theme from Oh My Posh official repo" -Action {

    $themesPath = "$env:LOCALAPPDATA\oh-my-posh-themes"
    if (-not (Test-Path $themesPath)) {
        New-Item -ItemType Directory -Force -Path $themesPath | Out-Null
    }

    $themeUrl  = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/paradox.omp.json"
    $themeDest = "$themesPath\paradox.omp.json"

    Invoke-WebRequest -Uri $themeUrl -OutFile $themeDest -UseBasicParsing
}

# ------------------------------
# 4️⃣ Download your profile
# ------------------------------
Invoke-Safe -Message "Downloading your PowerShell profile script" -Action {
    $profileUrl = "https://raw.githubusercontent.com/<USER>/<REPO>/main/Microsoft.PowerShell_profile.ps1"
    Invoke-WebRequest -Uri $profileUrl -OutFile $PROFILE -UseBasicParsing
}

# ------------------------------
# 5️⃣ Reload profile
# ------------------------------
Invoke-Safe -Message "Reloading PowerShell profile" -Action {
    . $PROFILE
}

Write-Host "`n🎉 PSX Profile Installed Successfully!" -ForegroundColor Cyan
Write-Host "Restart PowerShell to enjoy your upgraded terminal." -ForegroundColor Cyan
