#!/bin/bash

# Script to generate GPG key for package signing
# This should be run once to create the signing key

set -e

KEY_NAME="Amp CLI"
KEY_EMAIL="support@sourcegraph.com"
KEY_COMMENT="Package signing key"

# Create GPG key configuration
cat > /tmp/gpg-key-config <<EOF
%echo Generating GPG key for package signing
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: $KEY_NAME
Name-Comment: $KEY_COMMENT
Name-Email: $KEY_EMAIL
Expire-Date: 0
Passphrase: 
%commit
%echo Done
EOF

echo "Generating GPG key..."
gpg --batch --generate-key /tmp/gpg-key-config

# Get the key ID
KEY_ID=$(gpg --list-secret-keys --keyid-format=long | grep -A1 "sec " | grep -v "sec " | head -1 | awk '{print $1}' | cut -d'/' -f2)

echo "Generated key ID: $KEY_ID"

# Export public key
echo "Exporting public key..."
mkdir -p repository/gpg
gpg --armor --export $KEY_ID > repository/gpg/amp-cli.asc

echo "Public key exported to repository/gpg/amp-cli.asc"
echo ""
echo "IMPORTANT: Store the following information securely:"
echo "Key ID: $KEY_ID"
echo ""
echo "To export the private key for GitHub Secrets:"
echo "gpg --armor --export-secret-keys $KEY_ID"

# Clean up
rm /tmp/gpg-key-config

echo ""
echo "Add the following to GitHub Secrets:"
echo "GPG_PRIVATE_KEY: (output of: gpg --armor --export-secret-keys $KEY_ID)"
echo "GPG_KEY_ID: $KEY_ID"
