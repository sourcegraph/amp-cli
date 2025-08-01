#!/bin/bash
set -euo pipefail

VERSION="$1"
VERSION="${VERSION#v}"

echo "Building AUR package for version $VERSION"
echo "Current working directory: $(pwd)"
echo "Directory contents:"
ls -la

# Install required packages in Arch container
pacman -Syu --noconfirm git openssh github-cli sudo

# Create non-root user for makepkg (required by AUR)
useradd -m -G wheel builder
echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Change ownership of workspace to builder user
chown -R builder:builder /github/workspace 2>/dev/null || chown -R builder:builder $(pwd)

# Setup SSH for AUR
if [ -z "$AUR_SSH_PRIVATE_KEY" ]; then
  echo "AUR_SSH_PRIVATE_KEY environment variable not set"
  exit 1
fi

# SSH setup with verbose debugging -----------------------------------
mkdir -p ~/.ssh && chmod 700 ~/.ssh
echo "$AUR_SSH_PRIVATE_KEY" | tr -d '\r' > ~/.ssh/aur
chmod 600 ~/.ssh/aur

echo "SSH key setup complete. Testing SSH key format..."
ssh-keygen -l -f ~/.ssh/aur || echo "SSH key format check failed"

# record current host key with verbose output
echo "Running ssh-keyscan for aur.archlinux.org..."
ssh-keyscan -v -t ed25519,rsa aur.archlinux.org >> ~/.ssh/known_hosts 2>&1

echo "Contents of known_hosts:"
cat ~/.ssh/known_hosts

cat > ~/.ssh/config <<EOF
Host aur.archlinux.org
  User                 aur
  IdentityFile         ~/.ssh/aur
  IdentitiesOnly       yes
  StrictHostKeyChecking no
  UserKnownHostsFile   ~/.ssh/known_hosts
  LogLevel             DEBUG3
EOF

echo "SSH config created:"
cat ~/.ssh/config

echo "Testing SSH connection with verbose output..."
ssh -vvv -o BatchMode=yes -T aur@aur.archlinux.org 2>&1 || echo "SSH test failed as expected"

# Test SSH connection with our key specifically
echo "Testing SSH with our specific key..."
ssh -i ~/.ssh/aur -o StrictHostKeyChecking=no -o UserKnownHostsFile=~/.ssh/known_hosts -o IdentitiesOnly=yes -vvv -T aur@aur.archlinux.org 2>&1 || echo "SSH key test failed - likely permission issue"

# Set GIT_SSH_COMMAND to use our SSH key and config
export GIT_SSH_COMMAND="ssh -i ~/.ssh/aur -o StrictHostKeyChecking=no -o UserKnownHostsFile=~/.ssh/known_hosts -o IdentitiesOnly=yes"
echo "GIT_SSH_COMMAND set to: $GIT_SSH_COMMAND"

# Show public key for debugging
echo "Public key fingerprint from private key:"
ssh-keygen -y -f ~/.ssh/aur | ssh-keygen -lf - || echo "Could not extract public key"

# Download release files to calculate checksums
gh release download "v${VERSION}" --repo sourcegraph/amp-cli \
  --pattern "amp-linux-x64" --pattern "amp-linux-arm64"

# Calculate SHA256 checksums
amd64_sha=$(sha256sum amp-linux-x64 | cut -d' ' -f1)
arm64_sha=$(sha256sum amp-linux-arm64 | cut -d' ' -f1)

echo "AMD64 SHA: $amd64_sha"
echo "ARM64 SHA: $arm64_sha"

# Clean up
rm amp-linux-*

# Copy template to PKGBUILD and update with version and checksums
echo "Checking for PKGBUILD template..."
ls -la aur/ampcode/
echo "Copying PKGBUILD template..."
cp aur/ampcode/PKGBUILD.template aur/ampcode/PKGBUILD
echo "Updating PKGBUILD with version and checksums..."
sed -i "s/REPLACE_WITH_VERSION/$VERSION/g" aur/ampcode/PKGBUILD
sed -i "s/REPLACE_WITH_LINUX_AMD64_SHA256/$amd64_sha/g" aur/ampcode/PKGBUILD
sed -i "s/REPLACE_WITH_LINUX_ARM64_SHA256/$arm64_sha/g" aur/ampcode/PKGBUILD
echo "Updated PKGBUILD contents:"
cat aur/ampcode/PKGBUILD

# Clone AUR repository
git clone ssh://aur@aur.archlinux.org/ampcode.git aur-repo
cd aur-repo

# Copy our updated PKGBUILD to the AUR repo
cp ../aur/ampcode/PKGBUILD ./PKGBUILD

# Generate new .SRCINFO as non-root user
sudo -u builder makepkg --printsrcinfo > .SRCINFO

# Configure git
git config user.name "Amp"
git config user.email "amp@ampcode.com"

# Commit and push changes
git add PKGBUILD .SRCINFO
git commit -m "Update to version $VERSION

- Update pkgver to $VERSION
- Update download URLs for new release
- Update SHA256 checksums for x86_64 and aarch64

Automated update from GitHub Actions"

# Retry logic for AUR push
for i in {1..3}; do
  echo "Attempt $i/3 to push to AUR"
  # Try master first, then main as fallback
  if git push origin master 2>/dev/null || git push origin main; then
    echo "Successfully pushed to AUR on attempt $i"
    break
  else
    echo "AUR push failed on attempt $i, retrying..."
    sleep $((i * 2))
    if [ $i -eq 3 ]; then
      echo "Failed to push to AUR after 3 attempts"
      exit 1
    fi
  fi
done

cd ..

# Copy updated files back to our repository
echo "Copying updated files back to our repository..."
cp aur-repo/PKGBUILD aur/ampcode/PKGBUILD
cp aur-repo/.SRCINFO aur/ampcode/.SRCINFO

# Update local repository with retry logic
git config --local user.email "amp@ampcode.com"
git config --local user.name "Amp"

for i in {1..5}; do
  echo "Attempt $i/5 to commit and push local AUR changes"

  # Pull latest changes
  echo "Pulling latest changes..."
  git pull origin main || true

  # Add and commit changes
  echo "Adding changes to git..."
  echo "Files in aur/ampcode/:"
  ls -la aur/ampcode/
  git add aur/ampcode/
  echo "Git status after add:"
  git status
  if git commit -m "Update AUR package to $VERSION with checksums"; then
    # Try to push
    echo "Pushing changes..."
    if git push; then
      echo "Successfully pushed local changes on attempt $i"
      exit 0
    else
      echo "Push failed on attempt $i, retrying..."
      sleep $((i * 2))
    fi
  else
    echo "No changes to commit on attempt $i"
    exit 0
  fi
done

echo "Failed to push local changes after 5 attempts"
exit 1
