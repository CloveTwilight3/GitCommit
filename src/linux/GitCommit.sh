#!/bin/bash
# GitCommit v1.1.0
# Automated Git workflow tool

set -e

VERSION="1.1.0"
BRANCH="main"
NO_PULL=false

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}$1${NC}"
}

print_success() {
    echo -e "${GREEN}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}$1${NC}"
}

print_error() {
    echo -e "${RED}$1${NC}"
}

# Function to show usage
show_usage() {
    cat << EOF
GitCommit v${VERSION} - Automated Git Workflow
by CloveTwilight3

Usage: gitcommit [OPTIONS]

Options:
    -b, --branch BRANCH    Target branch (default: main)
    -n, --no-pull         Skip pulling from remote
    -h, --help            Show this help message
    -v, --version         Show version information

Examples:
    gitcommit                    # Commit to main branch
    gitcommit -b develop         # Commit to develop branch
    gitcommit -n                 # Skip pulling from remote
    gitcommit -b feature -n      # Commit to feature branch without pulling
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -b|--branch)
            BRANCH="$2"
            shift 2
            ;;
        -n|--no-pull)
            NO_PULL=true
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        -v|--version)
            echo "GitCommit v${VERSION}"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

print_info "GitCommit - Automated Git Workflow"
print_info "================================="
print_info "by CloveTwilight3"
print_info "Target branch: $BRANCH"
if [ "$NO_PULL" = true ]; then
    print_info "Mode: No pull (skip remote sync)"
fi
echo ""

# Check if we're in a Git repository
if [ ! -d ".git" ]; then
    print_error "[ERROR] Not in a Git repository!"
    print_warning "Please run this command from inside a Git repository."
    exit 1
fi

# Step 1: Switch to target branch
print_info "[1/5] Switching to $BRANCH branch..."
if ! git checkout "$BRANCH" 2>/dev/null; then
    print_error "[ERROR] Failed to switch to $BRANCH branch"
    exit 1
fi

# Step 2: Pull latest changes (unless -n/--no-pull is specified)
if [ "$NO_PULL" = false ]; then
    print_info "[2/5] Pulling latest changes..."
    if ! git pull origin "$BRANCH"; then
        print_error "[ERROR] Failed to pull changes. Please resolve conflicts manually."
        exit 1
    fi
else
    print_info "[2/5] Skipping pull (no pull mode)..."
fi

# Step 3: Add all changes
print_info "[3/5] Adding all changes..."
if ! git add .; then
    print_error "[ERROR] Failed to add files"
    exit 1
fi

# Step 4: Check if there are changes to commit
print_info "[4/5] Checking for changes..."
if [ -z "$(git status --porcelain)" ]; then
    print_success "[SUCCESS] No changes to commit! Repository is up to date."
    exit 0
fi

# Step 5: Get commit message from user
echo ""
print_info "Changes found! Time to commit:"
read -p "Enter your commit message: " commit_message

if [ -z "$commit_message" ]; then
    print_error "[ERROR] Commit message cannot be empty!"
    exit 1
fi

# Step 6: Commit changes
print_info "[4/5] Committing changes..."
if ! git commit -m "$commit_message"; then
    print_error "[ERROR] Failed to commit changes"
    exit 1
fi

# Step 7: Push to target branch
print_info "[5/5] Pushing to $BRANCH branch..."
if ! git push origin "$BRANCH"; then
    print_error "[ERROR] Failed to push changes"
    exit 1
fi

# Success!
echo ""
print_success "SUCCESS! Your changes have been committed and pushed to $BRANCH!"
print_success "Repository is now up to date."