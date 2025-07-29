#!/bin/bash

# Amp CLI Universal Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/sourcegraph/amp-cli/main/install.sh | bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Version to install (can be overridden with AMP_VERSION env var)
VERSION=${AMP_VERSION:-"1.0.0"}

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS and architecture
detect_os() {
    OS=""
    ARCH=""

    # Detect OS
    if [[ $OSTYPE == "linux-gnu"* ]]; then
        OS="linux"
    elif [[ $OSTYPE == "darwin"* ]]; then
        OS="darwin"
    elif [[ $OSTYPE == "msys" ]] || [[ $OSTYPE == "cygwin" ]]; then
        OS="windows"
    else
        print_error "Unsupported operating system: $OSTYPE"
        exit 1
    fi

    # Detect architecture
    case $(uname -m) in
    x86_64 | amd64)
        ARCH="amd64"
        ;;
    aarch64 | arm64)
        ARCH="arm64"
        ;;
    *)
        print_error "Unsupported architecture: $(uname -m)"
        exit 1
        ;;
    esac

    print_status "Detected OS: $OS, Architecture: $ARCH"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install using Homebrew (macOS/Linux)
install_homebrew() {
    print_status "Installing via Homebrew..."

    if ! command_exists brew; then
        print_error "Homebrew is not installed. Please install Homebrew first or use manual installation."
        return 1
    fi

    brew tap sourcegraph/amp-cli https://github.com/sourcegraph/amp-cli
    brew install amp
    return 0
}

# Install using Nix
install_nix() {
    print_status "Installing via Nix..."

    if ! command_exists nix; then
        print_error "Nix is not installed."
        return 1
    fi

    nix profile install github:sourcegraph/amp-cli
    return 0
}

# Install using AUR helpers (Arch Linux)
install_aur() {
    print_status "Installing via AUR..."

    if command_exists yay; then
        yay -S sourcegraph-amp
        return 0
    elif command_exists paru; then
        paru -S sourcegraph-amp
        return 0
    else
        print_warning "No AUR helper found (yay/paru). Trying manual AUR installation..."
        if command_exists git && command_exists makepkg; then
            tmpdir=$(mktemp -d)
            cd "$tmpdir"
            git clone https://aur.archlinux.org/sourcegraph-amp.git
            cd sourcegraph-amp
            makepkg -si --noconfirm
            cd /
            rm -rf "$tmpdir"
            return 0
        else
            print_error "git or makepkg not found. Cannot install from AUR."
            return 1
        fi
    fi
}

# Setup apt repository and install (Debian/Ubuntu)
install_deb() {
    print_status "Setting up apt repository and installing..."

    # Add repository key
    print_status "Adding repository GPG key..."
    if command_exists curl; then
        curl -fsSL https://github.com/sourcegraph/amp-cli/releases/download/gpg/amp-cli.asc | sudo gpg --dearmor -o /usr/share/keyrings/amp-cli.gpg
    elif command_exists wget; then
        wget -qO- https://github.com/sourcegraph/amp-cli/releases/download/gpg/amp-cli.asc | sudo gpg --dearmor -o /usr/share/keyrings/amp-cli.gpg
    else
        print_error "Neither curl nor wget found. Cannot download GPG key."
        return 1
    fi

    # Add repository source
    print_status "Adding apt repository..."
    echo "deb [signed-by=/usr/share/keyrings/amp-cli.gpg] https://github.com/sourcegraph/amp-cli/releases/download/debian stable main" | sudo tee /etc/apt/sources.list.d/amp-cli.list

    # Update package list and install
    print_status "Updating package list..."
    sudo apt update

    print_status "Installing amp..."
    sudo apt install -y amp

    return 0
}

# Fallback: Install .deb package directly
install_deb_direct() {
    print_status "Installing via direct .deb package download..."

    local deb_url="https://github.com/sourcegraph/amp-cli/releases/download/v${VERSION}/amp_${VERSION}-1_${ARCH}.deb"
    local deb_file="/tmp/amp_${VERSION}-1_${ARCH}.deb"

    print_status "Downloading $deb_url..."
    if command_exists curl; then
        curl -fsSL -o "$deb_file" "$deb_url"
    elif command_exists wget; then
        wget -q -O "$deb_file" "$deb_url"
    else
        print_error "Neither curl nor wget found. Cannot download package."
        return 1
    fi

    print_status "Installing package..."
    if command_exists apt; then
        sudo apt install -y "$deb_file"
    else
        sudo dpkg -i "$deb_file"
        sudo apt-get install -f -y || true
    fi

    rm -f "$deb_file"
    return 0
}

# Setup yum/dnf repository and install (RHEL/CentOS/Fedora)
install_rpm() {
    print_status "Setting up yum/dnf repository and installing..."

    # Add repository GPG key
    print_status "Adding repository GPG key..."
    sudo rpm --import https://github.com/sourcegraph/amp-cli/releases/download/gpg/amp-cli.asc

    # Add repository configuration
    print_status "Adding yum/dnf repository..."
    sudo tee /etc/yum.repos.d/amp-cli.repo >/dev/null <<EOF
[amp-cli]
name=Amp CLI Repository
baseurl=https://github.com/sourcegraph/amp-cli/releases/download/rpm/
enabled=1
gpgcheck=1
gpgkey=https://github.com/sourcegraph/amp-cli/releases/download/gpg/amp-cli.asc
EOF

    # Install package
    print_status "Installing amp..."
    if command_exists dnf; then
        sudo dnf install -y amp
    elif command_exists yum; then
        sudo yum install -y amp
    else
        print_error "No package manager found (dnf/yum)."
        return 1
    fi

    return 0
}

# Fallback: Install .rpm package directly
install_rpm_direct() {
    print_status "Installing via direct .rpm package download..."

    local rpm_arch
    if [[ $ARCH == "amd64" ]]; then
        rpm_arch="x86_64"
    else
        rpm_arch="aarch64"
    fi

    local rpm_url="https://github.com/sourcegraph/amp-cli/releases/download/v${VERSION}/amp-${VERSION}-1.${rpm_arch}.rpm"

    print_status "Installing from $rpm_url..."
    if command_exists dnf; then
        sudo dnf install -y "$rpm_url"
    elif command_exists yum; then
        sudo yum install -y "$rpm_url"
    elif command_exists rpm; then
        local rpm_file="/tmp/amp-${VERSION}-1.${rpm_arch}.rpm"
        if command_exists curl; then
            curl -fsSL -o "$rpm_file" "$rpm_url"
        elif command_exists wget; then
            wget -q -O "$rpm_file" "$rpm_url"
        else
            print_error "Neither curl nor wget found. Cannot download package."
            return 1
        fi
        sudo rpm -ivh "$rpm_file"
        rm -f "$rpm_file"
    else
        print_error "No RPM package manager found (dnf/yum/rpm)."
        return 1
    fi

    return 0
}

# Install using Chocolatey (Windows)
install_chocolatey() {
    print_status "Installing via Chocolatey..."

    if ! command_exists choco; then
        print_error "Chocolatey is not installed."
        return 1
    fi

    choco install amp -y
    return 0
}

# Install using winget (Windows)
install_winget() {
    print_status "Installing via winget..."

    if ! command_exists winget; then
        print_error "winget is not installed."
        return 1
    fi

    winget install Sourcegraph.Amp
    return 0
}

# Manual binary installation
install_manual() {
    print_status "Installing manually via binary download..."

    local binary_url="https://github.com/sourcegraph/amp-cli/releases/download/v${VERSION}/amp-${OS}-${ARCH}.tar.gz"
    local install_dir="/usr/local/bin"

    # Use user bin directory if not root
    if [[ $EUID -ne 0 ]]; then
        install_dir="$HOME/.local/bin"
        mkdir -p "$install_dir"
    fi

    print_status "Downloading $binary_url..."
    local tmpdir
    tmpdir=$(mktemp -d)
    local archive_file="$tmpdir/amp.tar.gz"

    if command_exists curl; then
        curl -fsSL -o "$archive_file" "$binary_url"
    elif command_exists wget; then
        wget -q -O "$archive_file" "$binary_url"
    else
        print_error "Neither curl nor wget found. Cannot download binary."
        return 1
    fi

    print_status "Extracting and installing to $install_dir..."
    cd "$tmpdir"
    tar -xzf "$archive_file"

    if [[ $EUID -eq 0 ]]; then
        cp amp "$install_dir/amp"
        chmod +x "$install_dir/amp"
    else
        cp amp "$install_dir/amp"
        chmod +x "$install_dir/amp"

        # Add to PATH if not already there
        if [[ ":$PATH:" != *":$install_dir:"* ]]; then
            echo ""
            print_warning "The amp binary was installed to $install_dir, which is not in your PATH."
            echo "To make 'amp' available in your shell, we need to add the following line to your shell configuration files:"
            echo ""
            echo '    export PATH="$HOME/.local/bin:$PATH"'
            echo ""
            echo "This will be added to:"
            [[ -f "$HOME/.bashrc" ]] && echo "  - $HOME/.bashrc"
            [[ -f "$HOME/.zshrc" ]] && echo "  - $HOME/.zshrc"
            echo ""
            read -p "Do you want to add this to your shell configuration files? (y/N): " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                print_status "Adding $install_dir to PATH in shell configuration files..."
                if [[ -f "$HOME/.bashrc" ]]; then
                    echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$HOME/.bashrc"
                fi
                if [[ -f "$HOME/.zshrc" ]]; then
                    echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$HOME/.zshrc" 2>/dev/null || true
                fi
                print_success "Shell configuration files updated successfully!"
                print_warning "Please restart your shell or run 'source ~/.bashrc' (or 'source ~/.zshrc') to apply the changes."
            else
                print_warning "Shell configuration not modified. You can manually add the following line to your ~/.bashrc or ~/.zshrc:"
                echo '    export PATH="$HOME/.local/bin:$PATH"'
                print_warning "Or use the full path: $install_dir/amp"
            fi
        fi
    fi

    cd /
    rm -rf "$tmpdir"
    return 0
}

# Detect Linux distribution
detect_linux_distro() {
    if [[ -f /etc/os-release ]]; then
        # shellcheck source=/dev/null
        . /etc/os-release
        echo "$ID"
    elif [[ -f /etc/debian_version ]]; then
        echo "debian"
    elif [[ -f /etc/redhat-release ]]; then
        echo "rhel"
    elif [[ -f /etc/arch-release ]]; then
        echo "arch"
    else
        echo "unknown"
    fi
}

# Main installation logic
main() {
    print_status "Amp CLI Universal Installer"
    print_status "Version: $VERSION"
    echo

    detect_os

    # Try different installation methods based on OS and available tools
    if [[ $OS == "darwin" ]]; then
        # macOS
        if install_homebrew; then
            print_success "Successfully installed Amp via Homebrew!"
        elif install_nix; then
            print_success "Successfully installed Amp via Nix!"
        elif install_manual; then
            print_success "Successfully installed Amp manually!"
        else
            print_error "Failed to install Amp. Please install manually."
            exit 1
        fi

    elif [[ $OS == "linux" ]]; then
        # Linux - detect distribution
        distro=$(detect_linux_distro)
        print_status "Detected Linux distribution: $distro"

        case "$distro" in
        arch | manjaro)
            if install_aur; then
                print_success "Successfully installed Amp via AUR!"
            elif install_nix; then
                print_success "Successfully installed Amp via Nix!"
            elif install_manual; then
                print_success "Successfully installed Amp manually!"
            else
                print_error "Failed to install Amp. Please install manually."
                exit 1
            fi
            ;;
        ubuntu | debian | pop | elementary)
            if install_deb; then
                print_success "Successfully installed Amp via apt repository!"
            elif install_deb_direct; then
                print_success "Successfully installed Amp via .deb package!"
            elif install_nix; then
                print_success "Successfully installed Amp via Nix!"
            elif install_homebrew; then
                print_success "Successfully installed Amp via Homebrew!"
            elif install_manual; then
                print_success "Successfully installed Amp manually!"
            else
                print_error "Failed to install Amp. Please install manually."
                exit 1
            fi
            ;;
        fedora | rhel | centos | rocky | almalinux)
            if install_rpm; then
                print_success "Successfully installed Amp via yum/dnf repository!"
            elif install_rpm_direct; then
                print_success "Successfully installed Amp via .rpm package!"
            elif install_nix; then
                print_success "Successfully installed Amp via Nix!"
            elif install_homebrew; then
                print_success "Successfully installed Amp via Homebrew!"
            elif install_manual; then
                print_success "Successfully installed Amp manually!"
            else
                print_error "Failed to install Amp. Please install manually."
                exit 1
            fi
            ;;
        *)
            # Unknown Linux distro - try common methods
            if install_nix; then
                print_success "Successfully installed Amp via Nix!"
            elif install_homebrew; then
                print_success "Successfully installed Amp via Homebrew!"
            elif install_manual; then
                print_success "Successfully installed Amp manually!"
            else
                print_error "Failed to install Amp. Please install manually."
                exit 1
            fi
            ;;
        esac

    elif [[ $OS == "windows" ]]; then
        # Windows
        if install_winget; then
            print_success "Successfully installed Amp via winget!"
        elif install_chocolatey; then
            print_success "Successfully installed Amp via Chocolatey!"
        else
            print_error "Failed to install Amp. Please install manually using winget or Chocolatey."
            exit 1
        fi

    else
        print_error "Unsupported operating system: $OS"
        exit 1
    fi

    echo
    print_success "Amp CLI has been installed successfully!"
    print_status "Run 'amp --help' to get started."

    # Check if amp is in PATH
    if ! command_exists amp; then
        print_warning "amp command not found in PATH. You may need to restart your shell or add the installation directory to your PATH."
    fi
}

# Run main function
main "$@"
