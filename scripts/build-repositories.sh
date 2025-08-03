#!/bin/bash
set -eo pipefail

VERSION="$1"
VERSION="${VERSION#v}"

echo "Building package repositories for version $VERSION"

# Debug: Show environment
echo "=== DEBUG: Environment Information ==="
echo "USER: ${USER:-<not set>}"
echo "HOME: ${HOME:-<not set>}"
echo "GPG_TTY: ${GPG_TTY:-<not set>}"
echo "GNUPG configuration directory: ${GNUPGHOME:-$HOME/.gnupg}"
echo "PWD: $(pwd)"
echo "GPG_KEY_ID provided: ${GPG_KEY_ID:-<not provided>}"
echo "GPG_PRIVATE_KEY provided: ${GPG_PRIVATE_KEY:+[REDACTED]}"
echo "GPG_PASSPHRASE provided: ${GPG_PASSPHRASE:+[REDACTED]}"
echo "======================================="

# Setup GPG with isolated GNUPGHOME for CI
echo "=== DEBUG: Configuring GPG for non-interactive mode ==="
export GNUPGHOME="${RUNNER_TEMP:-/tmp}/gnupg"
mkdir -p "$GNUPGHOME"
chmod 700 "$GNUPGHOME"
echo "Using GNUPGHOME: $GNUPGHOME"

# Only set GPG_TTY if we actually have a TTY
if tty -s 2>/dev/null; then
    export GPG_TTY=$(tty)
    echo "Setting GPG_TTY to: $GPG_TTY"
else
    echo "No TTY available, using loopback pinentry only"
fi

# Create GPG agent configuration for non-interactive mode
cat > "$GNUPGHOME/gpg-agent.conf" << EOF
allow-loopback-pinentry
EOF

cat > "$GNUPGHOME/gpg.conf" << EOF
use-agent
pinentry-mode loopback
batch
yes
no-tty
EOF

echo "GPG configuration files created in $GNUPGHOME"
echo "Contents of gpg.conf:"
cat "$GNUPGHOME/gpg.conf"
echo "Contents of gpg-agent.conf:"
cat "$GNUPGHOME/gpg-agent.conf"

# Setup GPG
if [ -n "${GPG_PRIVATE_KEY:-}" ]; then
    echo "=== DEBUG: Importing GPG private key ==="
    echo "GPG private key will be imported securely"

    # Import with explicit batch and pinentry-mode options
    # Use secure method that doesn't expose passphrase in command line
    if [ -n "${GPG_PASSPHRASE:-}" ]; then
        echo "Using provided GPG passphrase for key import"
        # Create temporary passphrase file with secure permissions
        PASSPHRASE_FILE="$GNUPGHOME/passphrase.tmp"
        echo "$GPG_PASSPHRASE" > "$PASSPHRASE_FILE"
        chmod 600 "$PASSPHRASE_FILE"

        # Import using passphrase file
        echo "$GPG_PRIVATE_KEY" | gpg --batch --yes --no-tty --pinentry-mode loopback --passphrase-file "$PASSPHRASE_FILE" --import 2>/dev/null

        # Securely remove passphrase file
        rm -f "$PASSPHRASE_FILE"
    else
        echo "No GPG passphrase provided, assuming unprotected key"
        echo "$GPG_PRIVATE_KEY" | gpg --batch --yes --no-tty --pinentry-mode loopback --import 2>/dev/null
    fi

    echo "=== DEBUG: Listing available keys after import ==="
    gpg --list-secret-keys --keyid-format LONG

    export GPG_KEY_ID="${GPG_KEY_ID}"
    echo "Using GPG_KEY_ID: $GPG_KEY_ID"
else
    echo "GPG_PRIVATE_KEY secret not set, skipping GPG setup"
    export GPG_KEY_ID=""
fi

# Download package artifacts (assuming they're already downloaded in workflow)
echo "Processing package artifacts..."

# Install repository tools
sudo apt-get update
sudo apt-get install -y createrepo-c dpkg-dev

# Prepare package directories
mkdir -p debs rpms
find artifacts -name "*.deb" -exec cp {} debs/ \;
find artifacts -name "*.rpm" -exec cp {} rpms/ \;

# Build Debian repository
echo "Building Debian repository..."
chmod +x ./scripts/build-debian-repo.sh
./scripts/build-debian-repo.sh debs repository/debian

# Build RPM repository
echo "Building RPM repository..."
chmod +x ./scripts/build-rpm-repo.sh
./scripts/build-rpm-repo.sh rpms repository/rpm

# Export GPG public key
if [ -n "$GPG_KEY_ID" ]; then
    echo "Exporting GPG public key for repositories..."
    mkdir -p repository/gpg
    gpg --armor --export "$GPG_KEY_ID" >repository/gpg/amp-cli.asc
    echo "GPG public key exported to repository/gpg/amp-cli.asc"
else
    echo "Warning: GPG_KEY_ID not set, creating placeholder"
    mkdir -p repository/gpg
    echo "# GPG key not available" >repository/gpg/amp-cli.asc
fi

# Create release assets
echo "Creating release assets..."
tar -czf debian-repo.tar.gz -C repository debian
tar -czf rpm-repo.tar.gz -C repository rpm

# Copy GPG key to release location
mkdir -p release-assets/gpg
cp repository/gpg/amp-cli.asc release-assets/gpg/ ||
    echo "GPG key not found, will be created manually"

# Upload repositories to release
version_tag="v${VERSION}"
gh release upload "$version_tag" \
    debian-repo.tar.gz \
    rpm-repo.tar.gz \
    release-assets/gpg/amp-cli.asc \
    --clobber

# Deploy to GCP bucket
if command -v gsutil >/dev/null 2>&1; then
    echo "Uploading repository files to gs://packages.ampcode.com/"
    gsutil -m rsync -r repository/ gs://packages.ampcode.com/

    echo "Repository deployment completed successfully"
else
    echo "Error: gsutil not available"
    exit 1
fi
