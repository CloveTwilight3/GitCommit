#Requires -RunAsAdministrator

# GitCommit Uninstaller v1.1.0
param(
    [string]$InstallPath = "$env:ProgramFiles\GitCommit"
)

function Show-Header {
    Clear-Host
    Write-Host @"
    ╔══════════════════════════════════════╗
    ║                                      ║
    ║       GitCommit Uninstaller          ║
    ║           Version 1.1.0              ║
    ║                                      ║
    ╚══════════════════════════════════════╝
"@ -ForegroundColor Red
    Write-Host ""
}

function Uninstall-GitCommit {
    Show-Header
    
    Write-Host "Uninstalling GitCommit from: $InstallPath" -ForegroundColor Yellow
    Write-Host ""
    
    # Remove from PATH
    Write-Host "[1/2] Removing from system PATH..." -ForegroundColor Yellow
    $CurrentPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
    $NewPath = $CurrentPath -replace [regex]::Escape(";$InstallPath"), ""
    $NewPath = $NewPath -replace [regex]::Escape("$InstallPath;"), ""
    $NewPath = $NewPath -replace [regex]::Escape("$InstallPath"), ""
    [Environment]::SetEnvironmentVariable("PATH", $NewPath, "Machine")
    Write-Host "      ✅ Removed from PATH" -ForegroundColor Green
    
    # Remove files
    Write-Host "[2/2] Removing files..." -ForegroundColor Yellow
    if (Test-Path $InstallPath) {
        Remove-Item $InstallPath -Recurse -Force
        Write-Host "      ✅ Files removed" -ForegroundColor Green
    } else {
        Write-Host "      ⚠️  Installation directory not found" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "✅ GitCommit uninstalled successfully!" -ForegroundColor Green
    Write-Host "You may need to restart your terminal for PATH changes to take effect." -ForegroundColor Yellow
    
    Read-Host "Press Enter to exit"
}

Uninstall-GitCommit