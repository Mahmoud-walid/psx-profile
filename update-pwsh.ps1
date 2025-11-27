Write-Host "`n⚡ Checking for latest PowerShell 7 release..." -ForegroundColor Cyan

try {
    $release = Invoke-RestMethod "https://api.github.com/repos/PowerShell/PowerShell/releases/latest" -ErrorAction Stop
} catch {
    Write-Host "❌ Failed to fetch release info: $_" -ForegroundColor Red
    exit 1
}

$assets = $release.assets

# Detect OS
$os = $PSVersionTable.OS
$isWindows = $env:OS -eq "Windows_NT"
$isLinux   = $PSVersionTable.Platform -eq "Unix"
$isMac     = $PSVersionTable.Platform -eq "MacOS"

if ($isWindows) {
    Write-Host "🪟 Detected OS: Windows" -ForegroundColor Yellow
    $asset = $assets | Where-Object { $_.name -match "win-x64\.msi$" }
}
elseif ($isLinux) {
    Write-Host "🐧 Detected OS: Linux" -ForegroundColor Yellow

    # Pick the correct package for your distro
    if (Test-Path "/etc/debian_version") {
        $asset = $assets | Where-Object { $_.name -match "linux-x64\.deb$" }
    }
    elseif (Test-Path "/etc/redhat-release") {
        $asset = $assets | Where-Object { $_.name -match "linux-x64\.rpm$" }
    }
    else {
        Write-Host "⚠ Unsupported Linux distro." -ForegroundColor Red
        exit 1
    }
}
elseif ($isMac) {
    Write-Host "🍎 Detected OS: macOS" -ForegroundColor Yellow
    $asset = $assets | Where-Object { $_.name -match "osx-x64\.pkg$" }
}
else {
    Write-Host "❌ Unsupported OS" -ForegroundColor Red
    exit 1
}

if (-not $asset) {
    Write-Host "❌ Could not find a matching PowerShell package for this OS." -ForegroundColor Red
    exit 1
}

$downloadUrl = $asset.browser_download_url
$downloadPath = Join-Path $env:TEMP $asset.name

Write-Host "⬇ Downloading: $($asset.name)" -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath -UseBasicParsing -ErrorAction Stop
} catch {
    Write-Host "❌ Download failed: $_" -ForegroundColor Red
    exit 1
}

Write-Host "📦 Installing PowerShell 7..." -ForegroundColor Cyan

try {
    if ($isWindows) {
        Start-Process msiexec.exe -ArgumentList "/i `"$downloadPath`" /qn /norestart" -Wait -ErrorAction Stop
    }
    elseif ($isLinux) {
        if ($asset.name -match "\.deb$") {
            sudo dpkg -i $downloadPath
            sudo apt --fix-broken install -y
        }
        elseif ($asset.name -match "\.rpm$") {
            sudo rpm -Uvh $downloadPath
        }
    }
    elseif ($isMac) {
        sudo installer -pkg $downloadPath -target /
    }
} catch {
    Write-Host "❌ Installation failed: $_" -ForegroundColor Red
    exit 1
}

Write-Host "✔ PowerShell updated successfully to version $($release.tag_name)" -ForegroundColor Green
Write-Host "🚀 Restart PowerShell to use the new version."
