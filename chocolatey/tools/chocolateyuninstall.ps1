$ErrorActionPreference = 'Stop'

$packageName = 'gitcommit'
$installDir = Join-Path $env:ProgramFiles $packageName

# Remove from PATH
Uninstall-ChocolateyPath $installDir 'Machine'

# Remove files
if (Test-Path $installDir) {
    Remove-Item $installDir -Recurse -Force
}

Write-Host "GitCommit uninstalled successfully!" -ForegroundColor Green