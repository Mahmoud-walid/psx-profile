Describe "🚀 PS7 Logging Tests" {

    BeforeAll {
        Write-Host "`n✨ Setting up Test Environment..." -ForegroundColor Cyan
        
        # 1. Setup Paths
        $CurrentDir = $PSScriptRoot
        if ([string]::IsNullOrEmpty($CurrentDir)) { $CurrentDir = Get-Location }

        $script:testEnvPath = Join-Path $CurrentDir "test-output-env"
        $parentDir = Split-Path -Parent $CurrentDir
        $script:ProfilePath = Join-Path $parentDir "Microsoft.PowerShell_profile.ps1"
        $script:OriginalAppData = $env:LOCALAPPDATA
        
        # 2. Create Test Environment
        if (Test-Path $script:testEnvPath) { Remove-Item $script:testEnvPath -Recurse -Force -ErrorAction SilentlyContinue }
        New-Item -ItemType Directory -Path $script:testEnvPath -Force | Out-Null
        $env:LOCALAPPDATA = $script:testEnvPath

        # =========================================================
        # 🛡️ CI FIXES (Mocks to prevent Profile errors in GitHub Actions)
        # =========================================================

        # A. Fix for Linux: "oh-my-posh not found"
        # We create a fake function so the profile doesn't crash when calling it.
        function Global:oh-my-posh { return "Write-Host 'Oh-My-Posh Mocked'" }

        # B. Fix for Windows: "The handle is invalid" (CursorPosition)
        # The profile tries to animate the banner. We disable this by setting the name to empty.
        # This stops the loop that manipulates the Console Cursor.
        $Global:PSX_Name = "" 

        # C. Fix for Headless Console: Mock Clear-Host
        # Real consoles can clear; CI logs cannot.
        function Global:Clear-Host { }

        # =========================================================

        # 3. Load Profile
        if (Test-Path $script:ProfilePath) {
            . $script:ProfilePath
        } else {
            Throw "Could not find profile file at: $script:ProfilePath"
        }

        $script:TestLogFile = Join-Path $script:testEnvPath "PS7Logs\ps7_open_logs.json"
    }

    It "📝 Should create log file automatically on load" {
        $exists = Test-Path $script:TestLogFile
        if ($exists) { Write-Host "   ✅ File found at: $script:TestLogFile" -ForegroundColor DarkGray }
        $exists | Should -Be $true
    }

    It "➕ Should contain the initial log entry" {
        if (-not (Test-Path $script:TestLogFile)) { Throw "Log file missing" }
        
        $content = Get-Content $script:TestLogFile -Raw 
        if ([string]::IsNullOrWhiteSpace($content)) { $content = "[]" }
        
        $json = $content | ConvertFrom-Json
        $json.Count | Should -BeGreaterThan 0
    }

    It "🔍 Get-PowerShell7-Open-Logs should run without error" {
        { Get-PowerShell7-Open-Logs } | Should -Not -Throw
    }

    It "🗑 Should delete logs when using -Delete switch" {
        Get-PowerShell7-Open-Logs -Delete
        
        $content = Get-Content $script:TestLogFile -Raw
        if ([string]::IsNullOrWhiteSpace($content)) { $content = "[]" }
        $json = $content | ConvertFrom-Json
        
        $json.Count | Should -Be 0
    }

    AfterAll {
        if ($script:OriginalAppData) {
            $env:LOCALAPPDATA = $script:OriginalAppData
        }
        
        if ($script:testEnvPath -and (Test-Path $script:testEnvPath)) { 
            Remove-Item $script:testEnvPath -Recurse -Force -ErrorAction SilentlyContinue 
        }
        
        Write-Host "`n🎉 Test Environment Cleaned up." -ForegroundColor Magenta
    }
}