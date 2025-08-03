#!/bin/bash
set -eo pipefail

# Source security hardening functions
source "$(dirname "$0")/security-hardening.sh"

VERSION="$1"
VERSION="${VERSION#v}"

echo "==============================================="
echo "AUR BUILD STARTED - VERSION $VERSION"
echo "==============================================="
echo "Current working directory: $(pwd)"
echo "Current user: $(whoami)"
echo "User ID: $(id)"

# Mask all secrets immediately
mask_secrets

echo "Environment variables (safe only):"
safe_env_log
echo ""

echo "Directory contents:"
ls -la
echo ""

echo "Git version and configuration:"
git --version || echo "Git not found"
git config --list --global || echo "No global git config"
echo ""

echo "SSH version:"
ssh -V || echo "SSH not found"
echo ""

# Install required packages in Arch container
echo "Installing required packages..."
pacman -Syu --noconfirm git openssh github-cli sudo
echo "Package installation completed"
echo ""

# Create non-root user for makepkg (required by AUR)
echo "Creating builder user for makepkg..."
useradd -m -G wheel builder
echo 'builder ALL=(ALL) NOPASSWD: ALL' >>/etc/sudoers
echo "Builder user created successfully"
echo "Builder user info:"
id builder
echo ""

# Configure git before any git operations
echo "Configuring git globally..."
git config --global user.name "Amp"
git config --global user.email "amp@ampcode.com"
git config --global init.defaultBranch main
echo "Git configured successfully"
echo "Git configuration:"
git config --list --global
echo ""

# Change ownership of workspace to builder user
echo "Changing ownership of workspace to builder user..."
echo "Attempting to change ownership of /github/workspace..."
if chown -R builder:builder /github/workspace 2>/dev/null; then
    echo "Successfully changed ownership to builder:builder for /github/workspace"
else
    echo "Failed to change ownership of /github/workspace, trying current directory $(pwd)..."
    if chown -R builder:builder $(pwd); then
        echo "Successfully changed ownership to builder:builder for $(pwd)"
    else
        echo "Failed to change ownership of current directory"
        exit 1
    fi
fi
echo ""

# Setup SSH for AUR
echo "Checking for AUR SSH private key..."
if [ -z "$AUR_SSH_PRIVATE_KEY" ]; then
    echo "ERROR: AUR_SSH_PRIVATE_KEY environment variable not set"
    exit 1
fi
echo "AUR_SSH_PRIVATE_KEY is configured"
echo ""

# SSH setup with secure configuration -----------------------------------
echo "Setting up secure SSH configuration..."

# Use the secure SSH setup function
setup_secure_ssh \
    "$AUR_SSH_PRIVATE_KEY" \
    "aur.archlinux.org" \
    "aur" \
    "aur.archlinux.org ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEuBKrPzbawxA/k2g6NcyV5jRsD26/Ux5kh6vqMfSiXz"

if ssh -o BatchMode=yes -o ConnectTimeout=10 aur@aur.archlinux.org exit 2>/dev/null; then
    echo "SSH connection successful"
else
    echo "SSH connection test completed (this may be expected for AUR)"
fi
echo ""

# Show public key for debugging
echo "Extracting public key fingerprint from private key..."
if ssh-keygen -y -f ~/.ssh/aur | ssh-keygen -lf -; then
    echo "Public key extraction successful"
else
    echo "ERROR: Could not extract public key from private key"
    exit 1
fi
echo ""

# Download release files to calculate checksums
echo "Downloading release files for checksum calculation..."
echo "Running: gh release download v${VERSION} --repo sourcegraph/amp-cli --pattern amp-linux-x64 --pattern amp-linux-arm64"
if gh release download "v${VERSION}" --repo sourcegraph/amp-cli \
    --pattern "amp-linux-x64" --pattern "amp-linux-arm64"; then
    echo "Release files downloaded successfully"
else
    echo "ERROR: Failed to download release files"
    exit 1
fi

echo "Downloaded files:"
ls -la amp-linux-*
echo ""

# Calculate SHA256 checksums
echo "Calculating SHA256 checksums..."
amd64_sha=$(sha256sum amp-linux-x64 | cut -d' ' -f1)
arm64_sha=$(sha256sum amp-linux-arm64 | cut -d' ' -f1)

echo "AMD64 SHA: $amd64_sha"
echo "ARM64 SHA: $arm64_sha"
echo ""

# Clean up
echo "Cleaning up downloaded files..."
rm amp-linux-*
echo "Cleanup completed"
echo ""

# Copy template to PKGBUILD and update with version and checksums
echo "==============================================="
echo "PREPARING PKGBUILD"
echo "==============================================="
echo "Checking for PKGBUILD template..."
if [ ! -d "aur/ampcode" ]; then
    echo "ERROR: aur/ampcode directory not found"
    echo "Current directory structure:"
    find . -name "PKGBUILD*" -o -name "aur" -type d | head -20
    exit 1
fi

ls -la aur/ampcode/
echo ""

if [ ! -f "aur/ampcode/PKGBUILD.template" ]; then
    echo "ERROR: PKGBUILD.template not found"
    exit 1
fi

echo "Copying PKGBUILD template..."
if cp aur/ampcode/PKGBUILD.template aur/ampcode/PKGBUILD; then
    echo "PKGBUILD template copied successfully"
else
    echo "ERROR: Failed to copy PKGBUILD template"
    exit 1
fi

echo "Updating PKGBUILD with version and checksums..."
sed -i "s/REPLACE_WITH_VERSION/$VERSION/g" aur/ampcode/PKGBUILD
sed -i "s/REPLACE_WITH_LINUX_AMD64_SHA256/$amd64_sha/g" aur/ampcode/PKGBUILD
sed -i "s/REPLACE_WITH_LINUX_ARM64_SHA256/$arm64_sha/g" aur/ampcode/PKGBUILD
echo "PKGBUILD updated successfully"
echo ""

echo "Updated PKGBUILD contents:"
cat aur/ampcode/PKGBUILD
echo ""

# Clone AUR repository
echo "==============================================="
echo "CLONING AUR REPOSITORY"
echo "==============================================="
echo "Current working directory: $(pwd)"
echo "Current user: $(whoami)"
echo "Git configuration:"
git config --list --global || echo "No global git config"
echo ""

echo "Attempting to clone AUR repository..."
echo "Running: git clone ssh://aur@aur.archlinux.org/ampcode.git aur-repo"
if git clone ssh://aur@aur.archlinux.org/ampcode.git aur-repo; then
    echo "AUR repository cloned successfully"
else
    GIT_EXIT_CODE=$?
    echo "ERROR: Failed to clone AUR repository (exit code: $GIT_EXIT_CODE)"
    echo ""
    echo "Debugging information:"
    echo "GIT_SSH_COMMAND: $GIT_SSH_COMMAND"
    echo "SSH configuration test:"
    ssh -T aur@aur.archlinux.org 2>&1 || true
    echo ""
    echo "Network connectivity test:"
    ping -c 3 aur.archlinux.org || true
    echo ""
    echo "DNS resolution test:"
    nslookup aur.archlinux.org || true
    exit 1
fi
echo ""

# Change ownership of the cloned repo to builder user
echo "Changing ownership of cloned repo to builder user..."
if chown -R builder:builder aur-repo; then
    echo "Successfully changed ownership of aur-repo to builder:builder"
else
    echo "ERROR: Failed to change ownership of aur-repo"
    exit 1
fi

echo "Entering aur-repo directory..."
cd aur-repo
echo "Current directory: $(pwd)"

# Trust this repo even though it's owned by a different user
git config --global --add safe.directory "$(pwd)"
echo "Added safe directory configuration for git"

echo "Directory contents:"
ls -la
echo ""

# Copy our updated PKGBUILD to the AUR repo
echo "Copying updated PKGBUILD to AUR repo..."
if cp ../aur/ampcode/PKGBUILD ./PKGBUILD; then
    echo "PKGBUILD copied successfully"
else
    echo "ERROR: Failed to copy PKGBUILD"
    exit 1
fi

# Generate new .SRCINFO as non-root user
echo "Generating .SRCINFO as builder user..."
if sudo -u builder makepkg --printsrcinfo >.SRCINFO; then
    echo ".SRCINFO generated successfully"
else
    echo "ERROR: Failed to generate .SRCINFO"
    exit 1
fi

echo "Generated .SRCINFO contents:"
cat .SRCINFO
echo ""

# Verify git configuration (already set globally)
echo "Verifying git configuration..."
git config --list
echo "Git configuration verified"
echo ""

# Commit and push changes
echo "Adding files to git..."
git add PKGBUILD .SRCINFO

# Check if there are any changes to commit
if git diff --cached --quiet; then
    echo "No changes detected – AUR package already at version $VERSION"
    echo ""
    echo "==============================================="
    echo "AUR BUILD COMPLETED (NO CHANGES NEEDED)"
    echo "==============================================="
    exit 0
fi

echo "Git status:"
git status
echo ""

echo "Committing changes..."
if git commit -m "Update to version $VERSION

- Update pkgver to $VERSION
- Update download URLs for new release
- Update SHA256 checksums for x86_64 and aarch64

Automated update from GitHub Actions"; then
    echo "Changes committed successfully"
else
    echo "ERROR: Failed to commit changes"
    exit 1
fi
echo ""

# Retry logic for AUR push
echo "==============================================="
echo "PUSHING TO AUR REPOSITORY"
echo "==============================================="
for i in {1..3}; do
    echo "Attempt $i/3 to push to AUR"
    echo "Running: git push origin master (trying master first, then main as fallback)"

    # Try master first, then main as fallback
    if git push origin master 2>&1; then
        echo "Successfully pushed to AUR (master branch) on attempt $i"
        break
    else
        MASTER_PUSH_EXIT_CODE=$?
        echo "Master branch push failed (exit code: $MASTER_PUSH_EXIT_CODE), trying main branch..."

        if git push origin main 2>&1; then
            echo "Successfully pushed to AUR (main branch) on attempt $i"
            break
        else
            MAIN_PUSH_EXIT_CODE=$?
            echo "Main branch push also failed (exit code: $MAIN_PUSH_EXIT_CODE)"
            echo "AUR push failed on attempt $i, retrying..."
            sleep $((i * 2))
            if [ $i -eq 3 ]; then
                echo "ERROR: Failed to push to AUR after 3 attempts"
                echo "Final debugging attempt:"
                echo "Git remote -v:"
                git remote -v
                echo "Git branch -a:"
                git branch -a
                echo "Git log --oneline -5:"
                git log --oneline -5
                exit 1
            fi
        fi
    fi
done
echo ""

echo "Returning to parent directory..."
cd ..
echo "Current directory: $(pwd)"
echo ""

# Copy updated files back to our repository
echo "==============================================="
echo "UPDATING LOCAL REPOSITORY"
echo "==============================================="
echo "Copying updated files back to our repository..."
if cp aur-repo/PKGBUILD aur/ampcode/PKGBUILD && cp aur-repo/.SRCINFO aur/ampcode/.SRCINFO; then
    echo "Files copied back successfully"
else
    echo "ERROR: Failed to copy files back"
    exit 1
fi

# Update local repository with retry logic
echo "Checking if we're inside a git repository..."
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Configuring local git..."
    git config --local user.email "amp@ampcode.com"
    git config --local user.name "Amp"
    echo "Local git configured"

    # Configure git to use GitHub token if available
    if [ -n "${GITHUB_TOKEN:-}" ]; then
        git remote set-url origin "https://x-access-token:${GITHUB_TOKEN}@github.com/sourcegraph/amp-cli.git"
    fi

    # Ensure we're on the main branch (not detached HEAD)
    git checkout main || git checkout -b main
else
    echo "Not inside a git repository – skipping local git configuration"
fi
echo ""

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    for i in {1..5}; do
        echo "Attempt $i/5 to commit and push local AUR changes"

        # Pull latest changes
        echo "Pulling latest changes..."
        if git pull origin main; then
            echo "Successfully pulled latest changes"
        else
            echo "Pull failed, continuing anyway..."
        fi

        # Add and commit changes
        echo "Adding changes to git..."
        echo "Files in aur/ampcode/:"
        ls -la aur/ampcode/
        git add aur/ampcode/
        echo "Git status after add:"
        git status

        if git commit -m "Update AUR package to $VERSION with checksums"; then
            echo "Changes committed successfully"
            # Try to push
            echo "Pushing changes..."
            if git push --set-upstream origin main; then
                echo "Successfully pushed local changes on attempt $i"
                echo ""
                echo "==============================================="
                echo "AUR BUILD COMPLETED SUCCESSFULLY"
                echo "==============================================="
                exit 0
            else
                PUSH_EXIT_CODE=$?
                echo "Push failed on attempt $i (exit code: $PUSH_EXIT_CODE), retrying..."
                sleep $((i * 2))
            fi
        else
            echo "No changes to commit on attempt $i"
            echo ""
            echo "==============================================="
            echo "AUR BUILD COMPLETED (NO CHANGES)"
            echo "==============================================="
            exit 0
        fi
    done

    echo "ERROR: Failed to push local changes after 5 attempts"
    exit 1
else
    echo "Not inside a git repository – skipping local workspace update"
    echo ""
    echo "==============================================="
    echo "AUR BUILD COMPLETED SUCCESSFULLY"
    echo "==============================================="
    exit 0
fi
