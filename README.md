# amp-cli

AI-powered coding assistant CLI tool.

## Installation

### Homebrew

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

### Manual Installation

Download the latest release from the [releases page](https://github.com/sourcegraph/amp-cli/releases).

## Usage

```bash
amp --help
```