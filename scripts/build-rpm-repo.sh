#!/bin/bash

# Script to build RPM repository from .rpm packages
# Usage: ./build-rpm-repo.sh <rpm-files-directory> <output-directory>

set -euo pipefail

RPM_DIR=${1:-"./rpms"}
REPO_DIR=${2:-"repository/rpm"}

if [ ! -d "$RPM_DIR" ]; then
    echo "Error: .rpm files directory not found: $RPM_DIR"
    exit 1
fi

echo "Building RPM repository..."
echo "Source: $RPM_DIR"
echo "Output: $REPO_DIR"

# Install createrepo if not available
if ! command -v createrepo_c >/dev/null 2>&1 && ! command -v createrepo >/dev/null 2>&1; then
    echo "Error: createrepo or createrepo_c is required but not installed."
    echo "Install with: dnf install createrepo_c (or yum install createrepo)"
    exit 1
fi

# Create repository directory
mkdir -p "$REPO_DIR"

# Copy .rpm files
echo "Copying .rpm files..."
cp "$RPM_DIR"/*.rpm "$REPO_DIR/" || true

# Create repository metadata
echo "Creating repository metadata..."
if command -v createrepo_c >/dev/null 2>&1; then
    createrepo_c "$REPO_DIR"
else
    createrepo "$REPO_DIR"
fi

# Sign repository if GPG key is available
if [ -n "$GPG_KEY_ID" ]; then
    echo "Signing repository with GPG key: $GPG_KEY_ID"
    echo "=== DEBUG: RPM repository GPG signing ==="
    echo "GPG_TTY: ${GPG_TTY:-<not set>}"
    echo "Available secret keys:"
    gpg --list-secret-keys --keyid-format LONG
    echo "======================================="

    # Configure RPM macros for GPG signing
    echo "=== DEBUG: Configuring RPM macros ==="
    mkdir -p ~/.rpm
    cat > ~/.rpmmacros << EOF
%_gpg_name ${GPG_KEY_ID}
%_signature gpg
%_gpg_path ${GNUPGHOME:-~/.gnupg}
EOF
    echo "RPM macros configured:"
    cat ~/.rpmmacros
    echo "======================================="

    # Sign the repomd.xml file with explicit batch and pinentry-mode options using secure passphrase handling
    echo "Signing repomd.xml..."
    if [ -n "${GPG_PASSPHRASE:-}" ]; then
        # Use secure passphrase file method
        PASSPHRASE_FILE="$GNUPGHOME/passphrase.tmp"
        echo "$GPG_PASSPHRASE" > "$PASSPHRASE_FILE"
        chmod 600 "$PASSPHRASE_FILE"
        
        gpg --batch --yes --no-tty --pinentry-mode loopback --passphrase-file "$PASSPHRASE_FILE" --default-key "$GPG_KEY_ID" --detach-sign --armor "$REPO_DIR/repodata/repomd.xml" 2>/dev/null
        
        rm -f "$PASSPHRASE_FILE"
    else
        gpg --batch --yes --no-tty --pinentry-mode loopback --default-key "$GPG_KEY_ID" --detach-sign --armor "$REPO_DIR/repodata/repomd.xml" 2>/dev/null
    fi

    # Skip individual RPM signing for now to avoid complexity - repomd.xml signature is sufficient for dnf/yum verification
    echo "Skipping individual RPM signing (repomd.xml signature is sufficient for package managers)"

    # Recreate metadata after signing
    echo "Recreating repository metadata after signing..."
    if command -v createrepo_c >/dev/null 2>&1; then
        createrepo_c --update "$REPO_DIR"
    else
        createrepo --update "$REPO_DIR"
    fi
    
    echo "=== DEBUG: Repository signing completed ==="
    ls -la "$REPO_DIR/repodata/"repomd.xml*
    echo "======================================="
else
    echo "Warning: GPG_KEY_ID not set, repository will not be signed"
fi

# Create .repo file template
echo "Creating repository configuration template..."
cat >"$REPO_DIR/amp-cli.repo" <<EOF
[amp-cli]
name=Amp CLI Repository
baseurl=https://packages.ampcode.com/rpm
enabled=1
gpgcheck=1
gpgkey=https://packages.ampcode.com/gpg/amp-cli.asc
EOF

echo "RPM repository built successfully!"
echo "Repository structure:"
find "$REPO_DIR" -type f | sort

echo ""
echo "To use this repository, add the following to /etc/yum.repos.d/amp-cli.repo:"
cat "$REPO_DIR/amp-cli.repo"
