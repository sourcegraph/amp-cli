# Repository Structure

This directory contains the package repository files for Amp CLI.

## Structure

```
repository/
├── debian/          # Debian/Ubuntu APT repository
│   ├── dists/
│   │   └── stable/
│   │       ├── Release
│   │       ├── Release.gpg
│   │       ├── InRelease
│   │       └── main/
│   │           ├── binary-amd64/
│   │           │   ├── Packages
│   │           │   └── Packages.gz
│   │           └── binary-arm64/
│   │               ├── Packages
│   │               └── Packages.gz
│   └── pool/
│       └── main/
│           ├── amp_1.0.0-1_amd64.deb
│           └── amp_1.0.0-1_arm64.deb
├── rpm/             # RHEL/Fedora YUM/DNF repository
│   ├── repodata/
│   │   ├── repomd.xml
│   │   ├── repomd.xml.asc
│   │   ├── primary.xml.gz
│   │   ├── filelists.xml.gz
│   │   └── other.xml.gz
│   ├── amp-1.0.0-1.x86_64.rpm
│   ├── amp-1.0.0-1.aarch64.rpm
│   └── amp-cli.repo
└── gpg/
    └── amp-cli.asc  # GPG public key for package verification
```

## Building Repositories

### Prerequisites

**For Debian repository:**
- `dpkg-deb` (usually available on Debian/Ubuntu)
- `gzip`
- GPG for signing

**For RPM repository:**
- `createrepo_c` or `createrepo`
- `rpm` tools
- GPG for signing

### Build Scripts

1. **Generate GPG key (one-time setup):**
   ```bash
   ./scripts/generate-gpg-key.sh
   ```

2. **Build Debian repository:**
   ```bash
   ./scripts/build-debian-repo.sh ./debs repository/debian
   ```

3. **Build RPM repository:**
   ```bash
   ./scripts/build-rpm-repo.sh ./rpms repository/rpm
   ```
