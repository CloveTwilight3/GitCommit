# Build Chocolatey package
$ErrorActionPreference = 'Stop'

$ProjectRoot = Split-Path $PSScriptRoot
$ChocolateyDir = Join-Path $ProjectRoot "chocolatey"
$SrcDir = Join-Path $ProjectRoot "src"
$ToolsDir = Join-Path $ChocolateyDir "tools"

Write-Host "Building Chocolatey package..." -ForegroundColor Cyan

# Ensure tools directory exists
if (-not (Test-Path $ToolsDir)) {
    New-Item -ItemType Directory -Path $ToolsDir -Force
}

# Copy source files to tools
Copy-Item "$SrcDir\GitCommit.ps1" -Destination $ToolsDir -Force
Copy-Item "$SrcDir\GitCommit.bat" -Destination $ToolsDir -Force

# Build package
Set-Location $ChocolateyDir
choco pack

Write-Host "Chocolatey package built successfully!" -ForegroundColor Green