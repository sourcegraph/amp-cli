# amp-cli

AI-powered coding assistant CLI tool.

## Installation

### Quick Install (Recommended)

**Linux/macOS:**
```bash
curl -fsSL https://raw.githubusercontent.com/sourcegraph/amp-cli/main/install.sh | bash
```

**Windows (PowerShell):**
```powershell
iwr -useb https://raw.githubusercontent.com/sourcegraph/amp-cli/main/install.ps1 | iex
```

These scripts automatically detect your OS and install amp using the best available method.

### Manual Installation by Platform

#### Homebrew

```bash
# Add the tap
brew tap sourcegraph/amp-cli https://github.com/sourcegraph/amp-cli

# Install amp
brew install amp
```

### Nix

```bash
# Run directly
nix run github:sourcegraph/amp-cli

# Install to profile
nix profile install github:sourcegraph/amp-cli

# Or add to your flake inputs
```

### Windows

#### Winget
```powershell
winget install Sourcegraph.Amp
```

#### Chocolatey
```powershell
choco install amp
```

### Arch Linux

#### AUR
```bash
# Using yay
yay -S amp-bin

# Using paru
paru -S amp-bin

# Manual AUR installation
git clone https://aur.archlinux.org/amp-bin.git
cd amp-bin
makepkg -si
```

### Debian/Ubuntu

#### .deb Package
```bash
# Download and install .deb package
wget https://github.com/sourcegraph/amp-cli/releases/download/v1.0.0/amp_1.0.0-1_amd64.deb
sudo dpkg -i amp_1.0.0-1_amd64.deb
sudo apt-get install -f  # Fix dependencies if needed
```

### RHEL/CentOS/Fedora

#### .rpm Package
```bash
# Download and install .rpm package
wget https://github.com/sourcegraph/amp-cli/releases/download/v1.0.0/amp-1.0.0-1.x86_64.rpm
sudo rpm -ivh amp-1.0.0-1.x86_64.rpm

# Or with dnf/yum (handles dependencies better)
sudo dnf install https://github.com/sourcegraph/amp-cli/releases/download/v1.0.0/amp-1.0.0-1.x86_64.rpm
```

### Manual Installation

Download the latest release from the [releases page](https://github.com/sourcegraph/amp-cli/releases).

## Usage

```bash
amp --help
```