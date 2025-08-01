#!/bin/bash
set -euo pipefail

VERSION="$1"
VERSION="${VERSION#v}"

echo "Building AUR package for version $VERSION"

# Install required packages in Arch container
pacman -Syu --noconfirm git openssh github-cli

# Setup SSH for AUR
if [ -z "$AUR_SSH_PRIVATE_KEY" ]; then
  echo "AUR_SSH_PRIVATE_KEY environment variable not set"
  exit 1
fi

mkdir -p ~/.ssh
echo "$AUR_SSH_PRIVATE_KEY" > ~/.ssh/aur
chmod 600 ~/.ssh/aur
chmod 700 ~/.ssh
ssh-keyscan -H aur.archlinux.org >> ~/.ssh/known_hosts

# Create SSH config for AUR
cat > ~/.ssh/config <<EOF
Host aur.archlinux.org
  User aur
  IdentityFile ~/.ssh/aur
  StrictHostKeyChecking no
EOF

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
cp aur/amp-bin/PKGBUILD.template aur/amp-bin/PKGBUILD
sed -i "s/REPLACE_WITH_VERSION/$VERSION/g" aur/amp-bin/PKGBUILD
sed -i "s/REPLACE_WITH_LINUX_AMD64_SHA256/$amd64_sha/g" aur/amp-bin/PKGBUILD
sed -i "s/REPLACE_WITH_LINUX_ARM64_SHA256/$arm64_sha/g" aur/amp-bin/PKGBUILD

# Clone AUR repository
git clone ssh://aur@aur.archlinux.org/amp-bin.git aur-repo
cd aur-repo

# Copy our updated PKGBUILD to the AUR repo
cp ../aur/amp-bin/PKGBUILD ./PKGBUILD

# Generate new .SRCINFO
makepkg --printsrcinfo > .SRCINFO

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
cp aur-repo/PKGBUILD aur/amp-bin/PKGBUILD
cp aur-repo/.SRCINFO aur/amp-bin/.SRCINFO

# Update local repository with retry logic
git config --local user.email "amp@ampcode.com"
git config --local user.name "Amp"

for i in {1..5}; do
  echo "Attempt $i/5 to commit and push local AUR changes"

  # Pull latest changes
  git pull origin main || true

  # Add and commit changes
  git add aur/amp-bin/
  if git commit -m "Update AUR package to $VERSION with checksums"; then
    # Try to push
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
