# Build NSIS installer
$ErrorActionPreference = 'Stop'

$ProjectRoot = Split-Path $PSScriptRoot
$NsisScript = Join-Path $ProjectRoot "installers\nsis\GitCommit-Installer.nsi"

Write-Host "Building NSIS installer..." -ForegroundColor Cyan

# Check if NSIS is installed
$nsisPath = "${env:ProgramFiles(x86)}\NSIS\makensis.exe"
if (-not (Test-Path $nsisPath)) {
    $nsisPath = "$env:ProgramFiles\NSIS\makensis.exe"
}

if (-not (Test-Path $nsisPath)) {
    Write-Host "NSIS not found! Please install NSIS from https://nsis.sourceforge.io/" -ForegroundColor Red
    exit 1
}

# Build installer
& $nsisPath $NsisScript

Write-Host "NSIS installer built successfully!" -ForegroundColor Green