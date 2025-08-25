# GitCommit v1.0.0
# Automated Git workflow tool

Write-Host "GitCommit - Automated Git Workflow" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host "by CloveTwilight3" -ForegroundColor Cyan
Write-Host ""

# Check if we're in a Git repository
if (-not (Test-Path ".git")) {
    Write-Host "[ERROR] Not in a Git repository!" -ForegroundColor Red
    Write-Host "Please run this command from inside a Git repository." -ForegroundColor Yellow
    exit 1
}

# Step 1: Switch to main branch
Write-Host "[1/5] Switching to main branch..." -ForegroundColor Yellow
git checkout main

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to switch to main branch" -ForegroundColor Red
    exit 1
}

# Step 2: Pull latest changes
Write-Host "[2/5] Pulling latest changes..." -ForegroundColor Yellow
git pull origin main

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to pull changes. Please resolve conflicts manually." -ForegroundColor Red
    exit 1
}

# Step 3: Add all changes
Write-Host "[3/5] Adding all changes..." -ForegroundColor Yellow
git add .

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to add files" -ForegroundColor Red
    exit 1
}

# Step 4: Check if there are changes to commit
Write-Host "[4/5] Checking for changes..." -ForegroundColor Yellow
$status = git status --porcelain
if (-not $status) {
    Write-Host "[SUCCESS] No changes to commit! Repository is up to date." -ForegroundColor Green
    exit 0
}

# Step 5: Get commit message from user
Write-Host ""
Write-Host "Changes found! Time to commit:" -ForegroundColor Green
$commitMessage = Read-Host "Enter your commit message"

if ([string]::IsNullOrWhiteSpace($commitMessage)) {
    Write-Host "[ERROR] Commit message cannot be empty!" -ForegroundColor Red
    exit 1
}

# Step 6: Commit changes
Write-Host "[4/5] Committing changes..." -ForegroundColor Yellow
git commit -m "$commitMessage"

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to commit changes" -ForegroundColor Red
    exit 1
}

# Step 7: Push to main branch
Write-Host "[5/5] Pushing to main branch..." -ForegroundColor Yellow
git push origin main

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to push changes" -ForegroundColor Red
    exit 1
}

# Success!
Write-Host ""
Write-Host "SUCCESS! Your changes have been committed and pushed!" -ForegroundColor Green
Write-Host "Repository is now up to date." -ForegroundColor Cyan