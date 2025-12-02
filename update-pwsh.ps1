# ================================
#      PowerShell 7 Updater
# ================================
$ErrorActionPreference = "Stop"

Write-Host "`n⚡ Checking for latest PowerShell 7 release..." -ForegroundColor Cyan

try {
    $release = Invoke-RestMethod "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
} catch {
    Write-Host "❌ Failed to fetch release info (Check Internet/Rate Limits)." -ForegroundColor Red
    exit 1
}

$assets = $release.assets
$tag = $release.tag_name

# Detect OS & Architecture
$isRunningOnWindows = $PSVersionTable.OS -match "Windows"
$isRunningOnLinux   = $PSVersionTable.Platform -eq "Unix" -and $PSVersionTable.OS -notmatch "Darwin"
$isMac     = $PSVersionTable.OS -match "Darwin"
$arch      = if ($env:PROCESSOR_ARCHITECTURE -match "ARM64") { "arm64" } else { "x64" }

$downloadUrl = $null
$packageName = $null

if ($isRunningOnWindows) {
    Write-Host "🪟 OS: Windows ($arch)" -ForegroundColor Yellow
    # Prefer MSI
    $asset = $assets | Where-Object { $_.name -match "win-$arch\.msi$" } | Select-Object -First 1
    if ($asset) {
        $downloadUrl = $asset.browser_download_url
        $packageName = $asset.name
    }
}
elseif ($isMac) {
    Write-Host "🍎 OS: macOS ($arch)" -ForegroundColor Yellow
    $asset = $assets | Where-Object { $_.name -match "osx-$arch\.pkg$" } | Select-Object -First 1
    if ($asset) {
        $downloadUrl = $asset.browser_download_url
        $packageName = $asset.name
    }
}
elseif ($isRunningOnLinux) {
    Write-Host "🐧 OS: Linux ($arch)" -ForegroundColor Yellow
    # Simple detection for deb/rpm
    if (Test-Path "/etc/debian_version") {
        $asset = $assets | Where-Object { $_.name -match "linux-$arch\.deb$" } | Select-Object -First 1
    } elseif (Test-Path "/etc/redhat-release") {
        $asset = $assets | Where-Object { $_.name -match "linux-$arch\.rpm$" } | Select-Object -First 1
    }
    
    if ($asset) {
        $downloadUrl = $asset.browser_download_url
        $packageName = $asset.name
    }
}

if (-not $downloadUrl) {
    Write-Host "❌ Could not find a matching package for your OS/Arch." -ForegroundColor Red
    exit 1
}

$tempDir = [System.IO.Path]::GetTempPath()
$savePath = Join-Path $tempDir $packageName

Write-Host "⬇ Downloading $packageName..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $downloadUrl -OutFile $savePath -UseBasicParsing

Write-Host "📦 Installing..." -ForegroundColor Cyan

try {
    if ($isRunningOnWindows) {
        Start-Process msiexec.exe -ArgumentList "/i `"$savePath`" /qn /norestart" -Wait
    } elseif ($isMac) {
        sudo installer -pkg $savePath -target /
    } elseif ($isRunningOnLinux) {
        if ($packageName -match "\.deb$") {
            sudo dpkg -i $savePath
            sudo apt-get install -f -y
        } elseif ($packageName -match "\.rpm$") {
            sudo rpm -Uvh $savePath
        }
    }
    Write-Host "✔ Update Complete: $tag" -ForegroundColor Green
} catch {
    Write-Host "❌ Installation failed: $_" -ForegroundColor Red
    exit 1
} finally {
    if (Test-Path $savePath) { Remove-Item $savePath -Force -ErrorAction SilentlyContinue }
}