# GPG Keys

This directory contains the GPG public key used for signing packages.

## Files

- `amp-cli.asc` - GPG public key for package verification

## Key Information

- **Key Name:** Amp CLI
- **Email:** support@sourcegraph.com
- **Purpose:** Package signing for apt and yum repositories

## Usage

### Import Key for APT (Debian/Ubuntu)
```bash
curl -fsSL https://github.com/sourcegraph/amp-cli/releases/download/gpg/amp-cli.asc | sudo gpg --dearmor -o /usr/share/keyrings/amp-cli.gpg
```

### Import Key for YUM/DNF (RHEL/Fedora)
```bash
sudo rpm --import https://github.com/sourcegraph/amp-cli/releases/download/gpg/amp-cli.asc
```

## Key Generation

The key was generated using:
```bash
./scripts/generate-gpg-key.sh
```

The private key is stored securely in GitHub Secrets for automated package signing.
