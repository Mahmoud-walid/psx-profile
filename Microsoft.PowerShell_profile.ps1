# ────────────────────────────────
# 📁 Setup PS7 Logging (LocalAppData)
# ────────────────────────────────

if (-not $env:LOCALAPPDATA -or $env:LOCALAPPDATA -eq "") {
    return  # Host did double-load profile → ignore duplicate
}

$logFolder = Join-Path $env:LOCALAPPDATA "PS7Logs"

# Create folder if missing
if (-not (Test-Path $logFolder)) {
    New-Item -ItemType Directory -Path $logFolder -Force | Out-Null
}

$Global:PS7_LogFile = Join-Path $logFolder "ps7_open_logs.json"

# Create file if missing
if (-not (Test-Path $Global:PS7_LogFile)) {
    "[]" | Out-File -FilePath $Global:PS7_LogFile -Encoding utf8 -Force
}

# ────────────────────────────────
# 📝 Logging Function
# ────────────────────────────────
function Write-PS7OpenLog {
    if (-not $Global:PS7_LogFile) { return }

    try {
        $isAdmin = (
            [Security.Principal.WindowsPrincipal](
                [Security.Principal.WindowsIdentity]::GetCurrent()
            )
        ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

        switch -Wildcard ($Host.Name) {
            "*Windows Terminal*" { $hostLabel = "WindowsTerminal" }
            "*Visual Studio*"    { $hostLabel = "VSCode" }
            "*ConsoleHost*"      { $hostLabel = "ConsoleHost" }
            default              { $hostLabel = "Unknown" }
        }

        $logs = @()
        $raw = Get-Content $Global:PS7_LogFile -Raw
        
        if ($raw.Trim() -ne "") {
            try { $logs = @($raw | ConvertFrom-Json) }
            catch { $logs = @() }
        }

        $logs += [PSCustomObject]@{
            Timestamp  = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            User       = $env:USERNAME
            Host       = $hostLabel
            Admin      = $isAdmin
            Path       = (Get-Location).Path
            SessionID  = $PID
            Machine    = $env:COMPUTERNAME
        }

        $logs | ConvertTo-Json -Depth 5 |
            Out-File -FilePath $Global:PS7_LogFile -Encoding utf8 -Force
    }
    catch {}
}

Write-PS7OpenLog

# ────────────────────────────────
# 📝 Get PS7 Open Logs Function
# ────────────────────────────────
function Get-PowerShell7-Open-Logs {
    param(
        [Alias("d")][switch]$Delete
    )

    if (-not $Global:PS7_LogFile -or -not (Test-Path $Global:PS7_LogFile)) {
        Write-Host "⚠ Log file not found." -ForegroundColor DarkYellow
        return
    }

    if ($Delete) {
        "[]" | Out-File -FilePath $Global:PS7_LogFile -Encoding utf8 -Force
        Write-Host "🗑 All logs deleted successfully." -ForegroundColor Yellow
        return
    }

    $logs = @()
    try {
        $raw = Get-Content -Path $Global:PS7_LogFile -Raw
        if ($raw.Trim() -eq "") { $raw = "[]" }
        $logs = $raw | ConvertFrom-Json
    } catch {
        Write-Host "⚠ Failed to read logs." -ForegroundColor Red
        return
    }

    if ($logs.Count -eq 0) {
        Write-Host "⚠ No logs found." -ForegroundColor DarkYellow
        return
    }

    # ────────────── Table Headers ──────────────
    $header = "{0,-20} {1,-10} {2,-15} {3,-6} {4,-30} {5,-8} {6,-15}" -f `
        "Timestamp","User","Host","Admin","Path","Session","Machine"
    Write-Host $header -ForegroundColor Cyan
    Write-Host ("─" * 120) -ForegroundColor DarkGray

    # ────────────── Table Rows ──────────────
    foreach ($log in $logs) {
        $line = "{0,-20} {1,-10} {2,-15} {3,-6} {4,-30} {5,-8} {6,-15}" -f `
            $log.Timestamp, $log.User, $log.Host, $log.Admin, $log.Path, $log.SessionID, $log.Machine

        if ($log.Admin) { $color = "Red" }
        elseif ($log.Host -eq "Unknown") { $color = "Yellow" }
        else { $color = "Green" }

        Write-Host $line -ForegroundColor $color
    }

    Write-Host ""  # extra spacing
}



# ────────────────────────────────
# 💻 Fancy PowerShell Welcome Banner
# ────────────────────────────────

# Changing colors + Elegant divider
Clear-Host

$line = "═" * 60

Write-Host ""
Write-Host "╔$line╗" -ForegroundColor DarkCyan
Write-Host "║" -NoNewline
Write-Host " 🚀 Welcome back, $($env:USERNAME)! 🚀 " -ForegroundColor Cyan -NoNewline
Write-Host "║"
Write-Host "╚$line╝" -ForegroundColor DarkCyan
Write-Host ""

# Write your name in a gradient of colors
Start-Sleep -Milliseconds 200

$banner = @(
    @{ text = "M"; color = "Red" },
    @{ text = "a"; color = "DarkRed" },
    @{ text = "h"; color = "Yellow" },
    @{ text = "m"; color = "Green" },
    @{ text = "o"; color = "Cyan" },
    @{ text = "u"; color = "Blue" },
    @{ text = "d"; color = "Magenta" },
    @{ text = "W"; color = "DarkMagenta" },
    @{ text = "a"; color = "DarkYellow" },
    @{ text = "l"; color = "Green" },
    @{ text = "i"; color = "Cyan" },
    @{ text = "d"; color = "DarkCyan" },
    @{ text = "_"; color = "White" },
    @{ text = "J"; color = "Red" },
    @{ text = "S"; color = "DarkRed" }
)

foreach ($part in $banner) {
    Write-Host -NoNewline $part.text -ForegroundColor $part.color
    Start-Sleep -Milliseconds 80
}

Write-Host ""
Write-Host ("═" * 60) -ForegroundColor DarkGray

Write-Host ("🕒 " + (Get-Date).ToString("dddd, MMMM dd yyyy HH:mm:ss")) -ForegroundColor DarkCyan
Write-Host ("📂 Current Directory: " + (Get-Location)) -ForegroundColor Gray
Write-Host ("═" * 60) -ForegroundColor DarkGray
Write-Host ""

# ────────────────────────────────
# 📊 PS7 Logs Summary under banner
# ────────────────────────────────

$logs = @()

if (Test-Path $Global:PS7_LogFile) {
    $raw = Get-Content $Global:PS7_LogFile -Raw
    if ($raw.Trim() -ne "") {
        try { $logs = @($raw | ConvertFrom-Json) } catch {}
    }
}

# Total logs saved
Write-Host ("📊 Total PS7 Sessions Logged: " + $logs.Count) -ForegroundColor Cyan

# Last 3 sessions
$lastLogs = $logs | Select-Object -Last 3

foreach ($log in $lastLogs) {
    if ($log.Admin) { $color = "Red" }
    elseif ($log.Host -eq "Unknown") { $color = "Yellow" }
    else { $color = "Green" }

    Write-Host "[$($log.Timestamp)] User: $($log.User) | Host: $($log.Host) | Admin: $($log.Admin)" -ForegroundColor $color
}

Write-Host ""  # Extra spacing


# Alias
Set-Alias trae "C:\Users\modyw\AppData\Local\Programs\Trae\Trae.exe"
Set-Alias pwsh-logs Get-PowerShell7-Open-Logs

# ──────────────────────────────
# 🔧 Load Oh My Posh Prompt
# ──────────────────────────────
$env:POSH_THEMES_PATH = "$env:LOCALAPPDATA\oh-my-posh-themes"
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\paradox.omp.json" | Invoke-Expression
