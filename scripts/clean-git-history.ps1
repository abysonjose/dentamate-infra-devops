# ============================================
# Clean Git History - Remove Exposed Credentials
# ============================================
# ⚠️ WARNING: This will rewrite Git history!
# ⚠️ Run this only if you understand the implications
# ============================================

param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Red
Write-Host "GIT HISTORY CLEANUP SCRIPT" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Red
Write-Host ""
Write-Host "⚠️  WARNING: This will rewrite Git history!" -ForegroundColor Yellow
Write-Host "⚠️  All commits containing MongoDB URI will be rewritten" -ForegroundColor Yellow
Write-Host "⚠️  You will need to force push after this" -ForegroundColor Yellow
Write-Host ""

if (-not $Force) {
    $confirm = Read-Host "Do you want to continue? (yes/no)"
    if ($confirm -ne "yes") {
        Write-Host "Aborted." -ForegroundColor Yellow
        exit 0
    }
}

$repoPath = Split-Path -Parent $PSScriptRoot
Set-Location $repoPath

Write-Host "`nStep 1: Creating backup branch..." -ForegroundColor Cyan
git branch backup-before-cleanup 2>$null
Write-Host "✅ Backup created: backup-before-cleanup" -ForegroundColor Green

Write-Host "`nStep 2: Removing MongoDB URI from history..." -ForegroundColor Cyan

# Pattern to remove: mongodb+srv://abyjp16:abyjp16@cluster0.ozkxezh.mongodb.net
$pattern = "mongodb\+srv://abyjp16:abyjp16@cluster0\.ozkxezh\.mongodb\.net"
$replacement = "mongodb+srv://username:password@cluster.mongodb.net"

Write-Host "Using git filter-branch to remove credentials..." -ForegroundColor Yellow

# Use git filter-repo if available, otherwise filter-branch
$hasFilterRepo = git filter-repo --version 2>$null
if ($hasFilterRepo) {
    Write-Host "Using git filter-repo (recommended)..." -ForegroundColor Green
    git filter-repo --replace-text <(echo "$pattern==>$replacement") --force
} else {
    Write-Host "Using git filter-branch..." -ForegroundColor Yellow
    Write-Host "⚠️  This may take a while for large repositories" -ForegroundColor Yellow
    
    git filter-branch --force --index-filter `
        "git rm --cached --ignore-unmatch -r . && git reset --hard" `
        --prune-empty --tag-name-filter cat -- --all 2>$null
    
    # Alternative: Use sed/awk approach
    git filter-branch --force --env-filter '
        if [ "$GIT_AUTHOR_EMAIL" != "" ]; then
            export GIT_COMMITTER_DATE="$GIT_AUTHOR_DATE"
            export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
            export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
        fi
    ' --tag-name-filter cat -- --branches --tags --force
}

Write-Host "`nStep 3: Cleaning up refs..." -ForegroundColor Cyan
git for-each-ref --format="%(refname)" refs/original/ | ForEach-Object {
    git update-ref -d $_
}

git reflog expire --expire=now --all
git gc --prune=now --aggressive

Write-Host "`n✅ Git history cleaned!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Verify no credentials remain: git grep -i 'abyjp16.*@cluster0' || echo 'Clean'" -ForegroundColor White
Write-Host "2. Force push: git push origin --force --all" -ForegroundColor Yellow
Write-Host "3. ⚠️  Rotate MongoDB password in Atlas dashboard!" -ForegroundColor Red
Write-Host ""
Write-Host "⚠️  IMPORTANT: Force pushing rewrites history on remote!" -ForegroundColor Red
Write-Host "⚠️  All team members will need to re-clone the repository" -ForegroundColor Red
