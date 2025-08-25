$ErrorActionPreference = 'Stop'

$packageName = 'gitcommit'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installDir = Join-Path $env:ProgramFiles $packageName

# Create installation directory
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
}

# Copy files
Copy-Item "$toolsDir\GitCommit.ps1" -Destination $installDir -Force
Copy-Item "$toolsDir\GitCommit.bat" -Destination $installDir -Force

# Add to PATH
Install-ChocolateyPath $installDir 'Machine'

Write-Host "GitCommit installed successfully!" -ForegroundColor Green
Write-Host "Usage: Open a new terminal and run 'GitCommit' from any Git repository" -ForegroundColor Cyan