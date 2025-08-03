param(
    [Parameter(Mandatory=$true)]
    [string]$Version,
    [string]$Arch = "",
    [string]$Platform = ""
)

$Version = $Version -replace '^v', ''
Write-Host "Building Chocolatey package for version $Version"

# Install Chocolatey if not already installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = `
        [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# Remove git SHA suffix to simplify version (e.g., 0.0.1753960840-gd58826 -> 0.0.1753960840)
$CleanVersion = $Version -replace '-g[a-f0-9]+$', ''

# Update version in nuspec
(Get-Content chocolatey/amp.nuspec) -replace '<version>.*</version>', "<version>$CleanVersion</version>" |
    Set-Content chocolatey/amp.nuspec

# Download the Windows executable to calculate checksum
$WindowsExeUrl = "https://packages.ampcode.com/binaries/cli/v$Version/amp-windows-x64.exe"
Write-Host "Downloading Windows executable from: $WindowsExeUrl"
Invoke-WebRequest -Uri $WindowsExeUrl -OutFile "amp-windows-x64.exe"
$WindowsChecksum = (Get-FileHash -Path "amp-windows-x64.exe" -Algorithm SHA256).Hash.ToLower()
Write-Host "Windows executable checksum: $WindowsChecksum"

# Copy template and update values
Copy-Item "chocolatey/tools/chocolateyinstall.ps1.template" "chocolatey/tools/chocolateyinstall.ps1" -Force

# Update download URL in install script (use original version with SHA for actual download)
(Get-Content chocolatey/tools/chocolateyinstall.ps1) -replace 'REPLACE_WITH_VERSION', $Version |
    Set-Content chocolatey/tools/chocolateyinstall.ps1

# Update checksum in install script
(Get-Content chocolatey/tools/chocolateyinstall.ps1) -replace 'REPLACE_WITH_WINDOWS_X64_SHA256', $WindowsChecksum |
    Set-Content chocolatey/tools/chocolateyinstall.ps1

# Clean up downloaded file
Remove-Item "amp-windows-x64.exe" -Force

# Build chocolatey package
Set-Location chocolatey
choco pack

# Test chocolatey package
$NupkgFile = Get-ChildItem -Name "amp.*.nupkg"
if ($NupkgFile) {
    Write-Host "Testing package: $NupkgFile"
    # Install with local source plus main repo for dependencies
    choco install amp -s ".;https://community.chocolatey.org/api/v2/" -f -y
    try {
        amp --help
    } catch {
        Write-Host "amp binary installed but may have terminal compatibility issues in CI"
    }
    choco uninstall amp -y
} else {
    Write-Host "No .nupkg file found to test"
    Get-ChildItem -Name "*.nupkg"
}

# Upload package to GitHub Release
$VersionTag = if ($Version.StartsWith('v')) { $Version } else { "v$Version" }
Write-Host "Uploading package to release $VersionTag"
$PackageFile = Get-ChildItem -Name "*.nupkg" | Select-Object -First 1
if ($PackageFile) {
    Write-Host "Found package file: $PackageFile"
    gh release upload $VersionTag $PackageFile --clobber --repo sourcegraph/amp-cli
} else {
    Write-Host "No .nupkg file found to upload"
    Get-ChildItem -Name "*.nupkg"
    exit 1
}

# 2025-08-01(ghuntley): disabled publishing to choco until initial package is through moderation

# Publish to Chocolatey if token is available
#if ($env:CHOCO_PUBLISH_TOKEN) {
#    Write-Host "Publishing to Chocolatey..."
#    choco push "amp.$CleanVersion.nupkg" -s https://push.chocolatey.org/ -k $env:CHOCO_PUBLISH_TOKEN
#} else {
#    Write-Host "CHOCO_PUBLISH_TOKEN not set, skipping Chocolatey publishing"
#}

Set-Location ..

# Configure git and commit changes
Write-Host "=== GIT DEBUGGING STARTED ==="
Write-Host "Current working directory: $(Get-Location)"
Write-Host "Git status before any operations:"
git status --porcelain=v1 2>&1 | Write-Host
Write-Host "Git branch list:"
git branch -a 2>&1 | Write-Host
Write-Host "Git remote info:"
git remote -v 2>&1 | Write-Host
Write-Host "Current HEAD:"
git rev-parse HEAD 2>&1 | Write-Host

git config --local user.email "amp@ampcode.com"
git config --local user.name "Amp"

# Configure git to use GitHub token if available
if ($env:GITHUB_TOKEN) {
    Write-Host "Setting up GitHub token authentication"
    git remote set-url origin "https://x-access-token:$($env:GITHUB_TOKEN)@github.com/sourcegraph/amp-cli.git"
    Write-Host "Remote URL updated to use token"
}

# Ensure we're on the main branch (not detached HEAD)
Write-Host "Attempting to checkout main branch..."
git checkout main 2>&1 | Write-Host
Write-Host "Checkout main exit code: $LASTEXITCODE"

if ($LASTEXITCODE -ne 0) {
    Write-Host "Main branch doesn't exist, creating it..."
    git checkout -b main 2>&1 | Write-Host
    Write-Host "Create main branch exit code: $LASTEXITCODE"
}

Write-Host "After branch setup:"
Write-Host "Current branch:"
git branch --show-current 2>&1 | Write-Host
Write-Host "All branches:"
git branch -a 2>&1 | Write-Host

# Retry logic for concurrent workflow conflicts
for ($i = 1; $i -le 5; $i++) {
    Write-Host "Attempt $i/5 to commit and push changes"

    # Pull latest changes
    Write-Host "Pulling latest changes from origin/main..."
    git pull origin main 2>&1 | Write-Host
    Write-Host "Pull exit code: $LASTEXITCODE"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Pull failed, continuing anyway..."
    }

    # Add and commit changes
    Write-Host "Adding files to git..."
    git add chocolatey/amp.nuspec chocolatey/tools/chocolateyinstall.ps1
    Write-Host "Files added. Attempting commit..."
    
    Write-Host "Git status before commit:"
    git status --porcelain=v1 2>&1 | Write-Host
    
    git commit -m "Update Chocolatey package to v$Version" 2>&1 | Write-Host
    Write-Host "Commit exit code: $LASTEXITCODE"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Commit successful. Current branch and HEAD info:"
        git branch --show-current 2>&1 | Write-Host
        git rev-parse HEAD 2>&1 | Write-Host
        git log --oneline -1 2>&1 | Write-Host
        
        # Try to push
        Write-Host "Attempting to push to origin main..."
        git push --set-upstream origin main 2>&1 | Write-Host
        Write-Host "Push exit code: $LASTEXITCODE"
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Successfully pushed changes on attempt $i"
            break
        } else {
            Write-Host "Push failed on attempt $i, retrying..."
            Write-Host "Current git state after failed push:"
            git status 2>&1 | Write-Host
            git branch -a 2>&1 | Write-Host
            Start-Sleep ($i * 2)
        }
    } else {
        Write-Host "No changes to commit on attempt $i"
        Write-Host "Git status after failed commit:"
        git status 2>&1 | Write-Host
        break
    }
}

if ($i -gt 5) {
    Write-Host "Failed to push after 5 attempts"
    exit 1
}

Write-Host "Chocolatey package built successfully"
