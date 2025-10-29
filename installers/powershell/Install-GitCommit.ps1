#Requires -RunAsAdministrator

# GitCommit Installer v1.1.0
# Professional installer for GitCommit automation tool

param(
    [string]$InstallPath = "$env:ProgramFiles\GitCommit"
)

function Show-Header {
    Clear-Host
    Write-Host @"
    ╔══════════════════════════════════════╗
    ║                                      ║
    ║         GitCommit Installer          ║
    ║           Version 1.1.0              ║
    ║                                      ║
    ║    Automated Git Workflow Tool       ║
    ║                                      ║
    ╚══════════════════════════════════════╝
"@ -ForegroundColor Cyan
    Write-Host ""
}

function Test-GitInstallation {
    try {
        $gitVersion = git --version 2>$null
        if ($gitVersion) {
            Write-Host "✅ Git found: $gitVersion" -ForegroundColor Green
            return $true
        }
    } catch {
        Write-Host "❌ Git not found! Please install Git first." -ForegroundColor Red
        Write-Host "   Download from: https://git-scm.com" -ForegroundColor Yellow
        return $false
    }
}

function Install-GitCommit {
    Show-Header
    
    Write-Host "Checking prerequisites..." -ForegroundColor Yellow
    if (-not (Test-GitInstallation)) {
        Read-Host "Press Enter to exit"
        exit 1
    }
    
    Write-Host ""
    Write-Host "Installing GitCommit to: $InstallPath" -ForegroundColor Green
    Write-Host ""
    
    # Create installation directory
    Write-Host "[1/4] Creating installation directory..." -ForegroundColor Yellow
    if (-not (Test-Path $InstallPath)) {
        New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
    }
    Write-Host "      ✅ Directory created" -ForegroundColor Green
    
    # Copy files
    Write-Host "[2/4] Copying GitCommit files..." -ForegroundColor Yellow
    
    # Get the correct source directory
    $CurrentLocation = Get-Location
    $ScriptDir = $PSScriptRoot
    if (-not $ScriptDir) {
        $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
    }
    
    # Navigate up from installers/powershell to project root, then to src
    $ProjectRoot = Split-Path (Split-Path $ScriptDir)
    $SourceDir = Join-Path $ProjectRoot "src"
    
    Write-Host "      Looking for files in: $SourceDir" -ForegroundColor Gray
    
    if (-not (Test-Path "$SourceDir\GitCommit.ps1")) {
        Write-Host "❌ Error: GitCommit.ps1 not found in $SourceDir" -ForegroundColor Red
        Write-Host "   Please make sure you're running this from the installers/powershell directory" -ForegroundColor Yellow
        Read-Host "Press Enter to exit"
        exit 1
    }
    
    if (-not (Test-Path "$SourceDir\GitCommit.bat")) {
        Write-Host "❌ Error: GitCommit.bat not found in $SourceDir" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
    
    Copy-Item "$SourceDir\GitCommit.ps1" -Destination $InstallPath -Force
    Copy-Item "$SourceDir\GitCommit.bat" -Destination $InstallPath -Force
    Write-Host "      ✅ Files copied" -ForegroundColor Green
    
    # Add to system PATH
    Write-Host "[3/4] Adding to system PATH..." -ForegroundColor Yellow
    $CurrentPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
    if ($CurrentPath -notlike "*$InstallPath*") {
        $NewPath = "$CurrentPath;$InstallPath"
        [Environment]::SetEnvironmentVariable("PATH", $NewPath, "Machine")
        Write-Host "      ✅ Added to PATH" -ForegroundColor Green
    } else {
        Write-Host "      ✅ Already in PATH" -ForegroundColor Green
    }
    
    # Create uninstaller
    Write-Host "[4/4] Creating uninstaller..." -ForegroundColor Yellow
    $UninstallerContent = @"
#Requires -RunAsAdministrator

Write-Host "Uninstalling GitCommit..." -ForegroundColor Yellow

# Remove from PATH
`$CurrentPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
`$NewPath = `$CurrentPath -replace [regex]::Escape(";$InstallPath"), ""
`$NewPath = `$NewPath -replace [regex]::Escape("$InstallPath;"), ""
`$NewPath = `$NewPath -replace [regex]::Escape("$InstallPath"), ""
[Environment]::SetEnvironmentVariable("PATH", `$NewPath, "Machine")

# Remove files
if (Test-Path "$InstallPath") {
    Remove-Item "$InstallPath" -Recurse -Force
}

Write-Host "✅ GitCommit uninstalled successfully!" -ForegroundColor Green
Write-Host "You may need to restart your terminal for PATH changes to take effect." -ForegroundColor Yellow
Read-Host "Press Enter to exit"
"@
    
    $UninstallerContent | Out-File "$InstallPath\Uninstall-GitCommit.ps1" -Encoding UTF8
    Write-Host "      ✅ Uninstaller created" -ForegroundColor Green
    
    # Installation complete
    Write-Host ""
    Write-Host "🎉 GitCommit installed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Usage:" -ForegroundColor Cyan
    Write-Host "  1. Open a NEW command prompt or PowerShell" -ForegroundColor White
    Write-Host "  2. Navigate to any Git repository" -ForegroundColor White
    Write-Host "  3. Type: GitCommit" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "To uninstall:" -ForegroundColor Cyan
    Write-Host "  Run as admin: $InstallPath\Uninstall-GitCommit.ps1" -ForegroundColor White
    Write-Host ""
    Write-Host "Note: You may need to restart your terminal for PATH changes to take effect." -ForegroundColor Yellow
    
    Read-Host "Press Enter to exit"
}

# Run the installer
Install-GitCommit