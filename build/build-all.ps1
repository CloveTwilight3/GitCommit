param(
    [Parameter(Mandatory=$true)]
    [string]$Version
)

$ErrorActionPreference = 'Stop'
$ProjectRoot = Split-Path $PSScriptRoot

Write-Host "Building GitCommit v$Version" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# Update version in all files
Write-Host "[1/4] Updating version numbers..." -ForegroundColor Yellow

# Update PowerShell script
$content = Get-Content "$ProjectRoot/src/GitCommit.ps1" -Raw
$content = $content -replace 'GitCommit v[\d.]+', "GitCommit v$Version"
$content | Out-File "$ProjectRoot/src/GitCommit.ps1" -Encoding UTF8 -NoNewline

# Update Chocolatey nuspec
[xml]$nuspec = Get-Content "$ProjectRoot/chocolatey/gitcommit.nuspec"
$nuspec.package.metadata.version = $Version
$nuspec.Save("$ProjectRoot/chocolatey/gitcommit.nuspec")

Write-Host "      ✅ Version updated to $Version" -ForegroundColor Green

# Build Chocolatey package
Write-Host "[2/4] Building Chocolatey package..." -ForegroundColor Yellow
& "$ProjectRoot/build/build-chocolatey.ps1"

# Build NSIS installer
Write-Host "[3/4] Building NSIS installer..." -ForegroundColor Yellow
& "$ProjectRoot/build/build-installer.ps1"

# Create portable ZIP
Write-Host "[4/4] Creating portable version..." -ForegroundColor Yellow
$portableDir = "$ProjectRoot/build/GitCommit-Portable"
if (Test-Path $portableDir) {
    Remove-Item $portableDir -Recurse -Force
}
New-Item -ItemType Directory -Path $portableDir -Force | Out-Null

Copy-Item "$ProjectRoot/src/GitCommit.ps1" -Destination $portableDir
Copy-Item "$ProjectRoot/src/GitCommit.bat" -Destination $portableDir
Copy-Item "$ProjectRoot/README.md" -Destination $portableDir
if (Test-Path "$ProjectRoot/LICENSE") {
    Copy-Item "$ProjectRoot/LICENSE" -Destination $portableDir
}

$zipPath = "$ProjectRoot/build/GitCommit-$Version-Portable.zip"
if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}
Compress-Archive -Path "$portableDir/*" -DestinationPath $zipPath

Write-Host "      ✅ Portable version created" -ForegroundColor Green

Write-Host ""
Write-Host "🎉 Build completed successfully!" -ForegroundColor Green
Write-Host "Files created:" -ForegroundColor Cyan
Write-Host "  - $ProjectRoot/chocolatey/gitcommit.$Version.nupkg" -ForegroundColor White
Write-Host "  - $ProjectRoot/installers/nsis/GitCommit-$Version-Setup.exe" -ForegroundColor White
Write-Host "  - $ProjectRoot/build/GitCommit-$Version-Portable.zip" -ForegroundColor White