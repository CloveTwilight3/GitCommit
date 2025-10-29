# GitCommit v1.1.0
# Automated Git workflow tool

param(
    [Alias("b")]
    [string]$Branch = "main",
    
    [Alias("n")]
    [switch]$NoPull
)

Write-Information "GitCommit - Automated Git Workflow" -InformationAction Continue
Write-Information "=================================" -InformationAction Continue
Write-Information "by CloveTwilight3" -InformationAction Continue
Write-Information "Target branch: $Branch" -InformationAction Continue
if ($NoPull) {
    Write-Information "Mode: No pull (skip remote sync)" -InformationAction Continue
}
Write-Information "" -InformationAction Continue

# Check if we're in a Git repository
if (-not (Test-Path ".git")) {
    Write-Error "[ERROR] Not in a Git repository!"
    Write-Warning "Please run this command from inside a Git repository."
    exit 1
}

# Step 1: Switch to target branch
Write-Information "[1/5] Switching to $Branch branch..." -InformationAction Continue
git checkout $Branch

if ($LASTEXITCODE -ne 0) {
    Write-Error "[ERROR] Failed to switch to $Branch branch"
    exit 1
}

# Step 2: Pull latest changes (unless -NoPull is specified)
if (-not $NoPull) {
    Write-Information "[2/5] Pulling latest changes..." -InformationAction Continue
    git pull origin $Branch

    if ($LASTEXITCODE -ne 0) {
        Write-Error "[ERROR] Failed to pull changes. Please resolve conflicts manually."
        exit 1
    }
} else {
    Write-Information "[2/5] Skipping pull (no pull mode)..." -InformationAction Continue
}

# Step 3: Add all changes
Write-Information "[3/5] Adding all changes..." -InformationAction Continue
git add .

if ($LASTEXITCODE -ne 0) {
    Write-Error "[ERROR] Failed to add files"
    exit 1
}

# Step 4: Check if there are changes to commit
Write-Information "[4/5] Checking for changes..." -InformationAction Continue
$status = git status --porcelain
if (-not $status) {
    Write-Information "[SUCCESS] No changes to commit! Repository is up to date." -InformationAction Continue
    exit 0
}

# Step 5: Get commit message from user
Write-Information "" -InformationAction Continue
Write-Information "Changes found! Time to commit:" -InformationAction Continue
$commitMessage = Read-Host "Enter your commit message"

if ([string]::IsNullOrWhiteSpace($commitMessage)) {
    Write-Error "[ERROR] Commit message cannot be empty!"
    exit 1
}

# Step 6: Commit changes
Write-Information "[4/5] Committing changes..." -InformationAction Continue
git commit -m "$commitMessage"

if ($LASTEXITCODE -ne 0) {
    Write-Error "[ERROR] Failed to commit changes"
    exit 1
}

# Step 7: Push to target branch
Write-Information "[5/5] Pushing to $Branch branch..." -InformationAction Continue
git push origin $Branch

if ($LASTEXITCODE -ne 0) {
    Write-Error "[ERROR] Failed to push changes"
    exit 1
}

# Success!
Write-Information "" -InformationAction Continue
Write-Information "SUCCESS! Your changes have been committed and pushed to $Branch!" -InformationAction Continue
Write-Information "Repository is now up to date." -InformationAction Continue