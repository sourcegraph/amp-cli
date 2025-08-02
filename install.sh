#!/bin/sh
# shellcheck shell=dash

# If you need an offline install, or you'd prefer to run the binary directly, head to
# https://github.com/sourcegraph/amp-cli/releases then pick the version and platform
# most appropriate for your deployment target.
#
# This is just a little script that selects and downloads the right `amp`. It does
# platform detection, downloads the installer, and runs it; that's it.
#

# This script is based off https://github.com/rust-lang/rustup/blob/f8d7b3baba7a63237cb2b82ef49a68a37dd0633c/rustup-init.sh

set -u

# Script version
SCRIPT_VERSION="1.0.0"

# Extension for Windows binaries; empty elsewhere
_ext=""

# If AMP_BINARY_ROOT is unset or empty, default it.
AMP_BINARY_ROOT="${AMP_BINARY_ROOT:-https://packages.ampcode.com/}"

# Store script arguments for dry-run detection
SCRIPT_ARGS="$*"

# Output control flags
VERBOSE=0
QUIET=0

LOGO="
                 ..
                ,cc:;;,'...
                .,;::cclllc:;,'.
           .''...   ....',;:clc'
          .;lllcc:;,,'...  .,cl:.
           ...',;:clllllc;. .:lc'
      ,:;,,....   ....,cll'  ,cl:.
     .,::clllcc:;,'.   'cl:. .:lc'
        ....,;cllll:,. .:ll,  'cl:.
            .':lllllc,  'cl:. ....
           ':ll:,;cll:. .;ll,
         .:clc,. .;lll,  'cc,.
        .:lc,.    'cll:.  ..
         ...      .;lll,
                   .,,,.
"

usage() {
    cat <<EOF
amp-install ${SCRIPT_VERSION}

USAGE:
    install.sh [OPTIONS]

DESCRIPTION:
    Downloads and installs the Amp CLI tool for your platform.
    Amp is an agentic coding tool, in research preview from Sourcegraph.

OPTIONS:
    -h, --help          Show this help message and exit
    -V, --version       Show version information and exit
    -v, --verbose       Enable verbose output
    -q, --quiet         Disable progress output (quiet mode)
    --dry-run           Show what would be done without executing
    --no-confirm        Skip interactive prompts and use defaults
    --doctor            Show system diagnostics for troubleshooting

ENVIRONMENT VARIABLES:
    AMP_BINARY_ROOT     Override the binary download URL root
                        (default: https://packages.ampcode.com/)
    AMP_DRY_RUN         Enable dry-run mode (same as --dry-run)
    AMP_NO_CONFIRM      Skip confirmation prompts (same as --no-confirm)
    HTTP_PROXY          HTTP proxy server URL
    HTTPS_PROXY         HTTPS proxy server URL
    NO_PROXY            Comma-separated list of hosts to bypass proxy

EXAMPLES:
    # Standard installation
    curl -fsSL https://packages.ampcode.com/install.sh | sh

    # Dry run to see what would happen
    ./install.sh --dry-run

    # Quiet installation with no prompts
    ./install.sh --quiet --no-confirm

    # Verbose installation to see detailed output
    ./install.sh --verbose

    # Run system diagnostics for troubleshooting
    ./install.sh --doctor

For more information, visit: https://ampcode.com/manual
EOF
}

version() {
    echo "amp-install ${SCRIPT_VERSION}"
    echo "Platform: $(uname -s) $(uname -m)"
    echo "Shell: $0"
}

doctor() {
    echo "amp-install ${SCRIPT_VERSION} - System Diagnostics"
    echo "=================================================="
    echo ""

    # Basic system information
    echo "System Information:"
    echo "  OS: $(uname -s)"
    echo "  Architecture: $(uname -m)"
    echo "  Kernel: $(uname -r)"
    if command -v sw_vers >/dev/null 2>&1; then
        echo "  macOS Version: $(sw_vers -productVersion)"
    fi
    echo "  Shell: $0"
    echo "  User: $(whoami)"
    echo "  Working Directory: $(pwd)"
    echo ""

    # Detected architecture
    echo "Architecture Detection:"
    get_architecture
    echo "  Detected: $RETVAL"
    echo ""

    # OS Detection
    echo "Operating System Detection:"
    if is_macos; then
        echo "  macOS: ✓"
    else
        echo "  macOS: ✗"
    fi

    if is_windows; then
        echo "  Windows: ✓"
    else
        echo "  Windows: ✗"
    fi

    if is_wsl; then
        echo "  WSL: ✓"
    else
        echo "  WSL: ✗"
    fi

    if is_archlinux; then
        echo "  Arch Linux: ✓"
    else
        echo "  Arch Linux: ✗"
    fi

    if is_nixos; then
        echo "  NixOS: ✓"
    else
        echo "  NixOS: ✗"
    fi

    if is_debian; then
        echo "  Debian/Ubuntu: ✓"
    else
        echo "  Debian/Ubuntu: ✗"
    fi

    if is_ubuntu; then
        echo "  Ubuntu: ✓"
    else
        echo "  Ubuntu: ✗"
    fi

    if is_redhat; then
        echo "  Red Hat: ✓"
    else
        echo "  Red Hat: ✗"
    fi

    if is_centos; then
        echo "  CentOS: ✓"
    else
        echo "  CentOS: ✗"
    fi

    if is_fedora; then
        echo "  Fedora: ✓"
    else
        echo "  Fedora: ✗"
    fi
    echo ""

    # Package Managers
    echo "Package Managers:"
    if has_homebrew; then
        echo "  Homebrew: ✓ ($(brew --version 2>/dev/null | head -1))"
        if is_homebrew_tapped; then
            echo "    sourcegraph/amp-cli tap: ✓"
        else
            echo "    sourcegraph/amp-cli tap: ✗"
        fi
        echo "    All taps:"
        brew tap 2>/dev/null | sed 's/^/      /' || echo "      (unable to list taps)"
    else
        echo "  Homebrew: ✗"
    fi

    if has_nix; then
        echo "  Nix: ✓ ($(nix --version 2>/dev/null || nix-env --version 2>/dev/null | head -1))"
    else
        echo "  Nix: ✗"
    fi

    if has_npm; then
        echo "  npm: ✓ ($(npm --version 2>/dev/null))"
    else
        echo "  npm: ✗"
    fi

    if has_yarn; then
        echo "  yarn: ✓ ($(yarn --version 2>/dev/null))"
    else
        echo "  yarn: ✗"
    fi

    if has_pnpm; then
        echo "  pnpm: ✓ ($(pnpm --version 2>/dev/null))"
    else
        echo "  pnpm: ✗"
    fi

    if has_choco; then
        echo "  Chocolatey: ✓ ($(choco --version 2>/dev/null | head -1))"
    else
        echo "  Chocolatey: ✗"
    fi

    # AUR helpers (Arch Linux only)
    if is_archlinux; then
        echo "  AUR Helpers:"
        if has_cmd yay; then
            echo "    yay: ✓ ($(yay --version 2>/dev/null | head -1))"
        else
            echo "    yay: ✗"
        fi

        if has_cmd paru; then
            echo "    paru: ✓ ($(paru --version 2>/dev/null | head -1))"
        else
            echo "    paru: ✗"
        fi
    fi

    # Debian/Ubuntu package managers
    if is_debian || is_ubuntu; then
        if has_cmd apt; then
            echo "  apt: ✓ ($(apt --version 2>/dev/null | head -1))"
        else
            echo "  apt: ✗"
        fi

        if has_cmd snap; then
            echo "  snap: ✓ ($(snap --version 2>/dev/null | head -1))"
        else
            echo "  snap: ✗"
        fi

        if has_cmd flatpak; then
            echo "  flatpak: ✓ ($(flatpak --version 2>/dev/null | head -1))"
        else
            echo "  flatpak: ✗"
        fi
    fi

    # RedHat/CentOS package managers
    if is_redhat || is_centos; then
        if has_cmd dnf; then
            echo "  dnf: ✓ ($(dnf --version 2>/dev/null | head -1))"
        else
            echo "  dnf: ✗"
        fi

        if has_cmd yum; then
            echo "  yum: ✓ ($(yum --version 2>/dev/null | head -1))"
        else
            echo "  yum: ✗"
        fi

        if has_cmd rpm; then
            echo "  rpm: ✓ ($(rpm --version 2>/dev/null | head -1))"
        else
            echo "  rpm: ✗"
        fi

        if has_cmd snap; then
            echo "  snap: ✓ ($(snap --version 2>/dev/null | head -1))"
        else
            echo "  snap: ✗"
        fi
    fi

    if has_vscode; then
        echo "  VS Code: ✓ ($(code --version 2>/dev/null | head -1))"
        if code --list-extensions 2>/dev/null | grep -q "sourcegraph.amp"; then
            echo "    Amp extension: ✓"
        else
            echo "    Amp extension: ✗"
        fi
    else
        echo "  VS Code: ✗"
    fi

    if has_vscode_insiders; then
        echo "  VS Code Insiders: ✓ ($(code-insiders --version 2>/dev/null | head -1))"
        if code-insiders --list-extensions 2>/dev/null | grep -q "sourcegraph.amp"; then
            echo "    Amp extension: ✓"
        else
            echo "    Amp extension: ✗"
        fi
    else
        echo "  VS Code Insiders: ✗"
    fi

    if has_windsurf; then
        echo "  Windsurf: ✓ ($(windsurf --version 2>/dev/null | head -1))"
        if windsurf --list-extensions 2>/dev/null | grep -q "sourcegraph.amp"; then
            echo "    Amp extension: ✓"
        else
            echo "    Amp extension: ✗"
        fi
    else
        echo "  Windsurf: ✗"
    fi

    if has_cursor; then
        echo "  Cursor: ✓ ($(cursor --version 2>/dev/null | head -1))"
        if cursor --list-extensions 2>/dev/null | grep -q "sourcegraph.amp"; then
            echo "    Amp extension: ✓"
        else
            echo "    Amp extension: ✗"
        fi
    else
        echo "  Cursor: ✗"
    fi

    if has_vscodium; then
        echo "  VSCodium: ✓ ($(codium --version 2>/dev/null | head -1))"
        if codium --list-extensions 2>/dev/null | grep -q "sourcegraph.amp"; then
            echo "    Amp extension: ✓"
        else
            echo "    Amp extension: ✗"
        fi
    else
        echo "  VSCodium: ✗"
    fi
    echo ""

    # Required commands
    echo "Required Commands:"
    local _commands="curl wget mktemp chmod mkdir rm rmdir uname"
    for cmd in $_commands; do
        if has_cmd "$cmd"; then
            echo "  $cmd: ✓ ($(command -v "$cmd"))"
        else
            echo "  $cmd: ✗ (required)"
        fi
    done
    echo ""

    # Environment Variables
    echo "Environment Variables:"
    echo "  AMP_BINARY_ROOT: ${AMP_BINARY_ROOT:-<default>}"
    echo "  AMP_DRY_RUN: ${AMP_DRY_RUN:-<not set>}"
    echo "  AMP_NO_CONFIRM: ${AMP_NO_CONFIRM:-<not set>}"
    echo "  NIXPKGS_ALLOW_UNFREE: ${NIXPKGS_ALLOW_UNFREE:-<not set>}"
    echo "  HTTP_PROXY: ${HTTP_PROXY:-<not set>}"
    echo "  HTTPS_PROXY: ${HTTPS_PROXY:-<not set>}"
    echo "  NO_PROXY: ${NO_PROXY:-<not set>}"
    echo "  TERM: ${TERM:-<not set>}"
    echo "  PATH: $PATH"
    echo ""

    # Network connectivity test
    echo "Network Connectivity:"
    if command -v curl >/dev/null 2>&1; then
        if curl -s --connect-timeout 5 "$AMP_BINARY_ROOT/" >/dev/null 2>&1; then
            echo "  Binary root accessible: ✓ ($AMP_BINARY_ROOT)"
        else
            echo "  Binary root accessible: ✗ ($AMP_BINARY_ROOT)"
        fi
    else
        echo "  Cannot test connectivity: curl not available"
    fi
    echo ""

    # Nix profile status
    if has_nix && has_cmd nix; then
        echo "Nix Profile Status:"
        if nix --extra-experimental-features nix-command --extra-experimental-features flakes profile list 2>/dev/null; then
            echo "  Profile list: ✓"
        else
            echo "  Profile list: ✗ (experimental features may be disabled)"
        fi
        echo ""
    fi

    # Temporary directory test
    echo "System Tests:"
    local _test_dir
    if _test_dir="$(mktemp -d 2>/dev/null)"; then
        echo "  Temp directory creation: ✓ ($_test_dir)"
        rmdir "$_test_dir" 2>/dev/null
    else
        echo "  Temp directory creation: ✗"
    fi

    # File permissions test
    if [ -w "$(pwd)" ]; then
        echo "  Current directory writable: ✓"
    else
        echo "  Current directory writable: ✗"
    fi

    echo ""
    echo "Diagnostics complete. Share this output when reporting issues."
}

main() {
    # Parse arguments first to set QUIET/VERBOSE flags
    local need_tty=yes
    local dry_run=no
    for arg in "$@"; do
        case "$arg" in
        --help | -h)
            print_logo
            usage
            exit 0
            ;;
        --version | -V)
            print_logo
            version
            exit 0
            ;;
        --doctor)
            doctor
            exit 0
            ;;
        --verbose | -v)
            VERBOSE=1
            ;;
        --quiet | -q)
            QUIET=1
            ;;
        --no-confirm)
            need_tty=no
            ;;
        --dry-run)
            dry_run=yes
            ;;
        *)
            continue
            ;;
        esac
    done

    # Check environment variables
    if [ "${AMP_NO_CONFIRM-}" ]; then
        need_tty=no
    fi
    if [ "${AMP_DRY_RUN-}" ]; then
        dry_run=yes
    fi

    # Now print logo (respects QUIET flag)
    print_logo

    need_cmd uname
    need_cmd mktemp
    need_cmd chmod
    need_cmd mkdir
    need_cmd rm
    need_cmd rmdir
    need_cmd curl

    migrate
    install_vscode_extension
    install_cli

    return "$_retval"
}

get_architecture() {
    local _ostype _cputype _arch
    _ostype="$(uname -s)"
    _cputype="$(uname -m)"

    if [ "$_ostype" = Linux ]; then
        if [ "$(uname -o)" = Android ]; then
            _ostype=Android
        fi
    fi

    if [ "$_ostype" = Darwin ]; then
        # Darwin `uname -m` can lie due to Rosetta shenanigans. If you manage to
        # invoke a native shell binary and then a native uname binary, you can
        # get the real answer, but that's hard to ensure, so instead we use
        # `sysctl` (which doesn't lie) to check for the actual architecture.
        if [ "$_cputype" = i386 ]; then
            # Handling i386 compatibility mode in older macOS versions (<10.15)
            # running on x86_64-based Macs.
            # Starting from 10.15, macOS explicitly bans all i386 binaries from running.
            # See: <https://support.apple.com/en-us/HT208436>

            # Avoid `sysctl: unknown oid` stderr output and/or non-zero exit code.
            if sysctl hw.optional.x86_64 2>/dev/null || true | grep -q ': 1'; then
                _cputype=x86_64
            fi
        elif [ "$_cputype" = x86_64 ]; then
            # Handling x86-64 compatibility mode (a.k.a. Rosetta 2)
            # in newer macOS versions (>=11) running on arm64-based Macs.
            # Rosetta 2 is built exclusively for x86-64 and cannot run i386 binaries.

            # Avoid `sysctl: unknown oid` stderr output and/or non-zero exit code.
            if sysctl hw.optional.arm64 2>/dev/null || true | grep -q ': 1'; then
                _cputype=arm64
            fi
        fi
    fi

    case "$_ostype" in
    Linux)
        _ostype=linux
        ;;

    Darwin)
        _ostype=darwin
        ;;

    *)
        err "unrecognized OS type: $_ostype"
        ;;

    esac

    case "$_cputype" in
    aarch64 | arm64)
        _cputype=aarch64
        ;;

    x86_64 | x86-64 | x64 | amd64)
        _cputype=x86_64
        ;;

    *)
        err "unknown CPU type: $_cputype"
        ;;

    esac

    _arch="${_cputype}-${_ostype}"

    RETVAL="$_arch"
}

say() {
    if [ "$QUIET" -eq 0 ]; then
        printf 'amp-install: %s\n' "$1"
    fi
}

verbose() {
    if [ "$VERBOSE" -eq 1 ]; then
        printf 'amp-install (verbose): %s\n' "$1" >&2
    fi
}

err() {
    printf 'amp-install: %s\n' "$1" >&2
    exit 1
}

need_cmd() {
    if ! has_cmd "$1"; then
        err "need '$1' (command not found)"
    fi
}

has_cmd() {
    command -v "$1" >/dev/null 2>&1
}

assert_nz() {
    if [ -z "$1" ]; then err "assert_nz $2"; fi
}

# Run a command that should never fail. If the command fails execution
# will immediately terminate with an error showing the failing
# command.
ensure() {
    if ! "$@"; then err "command failed: $*"; fi
}

# Run a command, with dry-run support
run_cmd() {
    # Check for dry-run flag in arguments to main script
    for arg in $SCRIPT_ARGS; do
        if [ "$arg" = "--dry-run" ]; then
            printf 'would run: %s\n' "$*" 1>&2
            return 0
        fi
    done

    if [ "${AMP_DRY_RUN-}" ]; then
        printf 'would run: %s\n' "$*" 1>&2
        return 0
    else
        verbose "Running: $*"
        "$@"
    fi
}

print_logo() {
    if [ "$QUIET" -eq 1 ]; then
        return
    fi

    # Only use colors if terminal supports them
    if [ -t 1 ] && [ "${TERM+set}" = 'set' ]; then
        case "$TERM" in
        xterm* | rxvt* | urxvt* | linux* | vt*)
            RED='\033[0;31m'
            NC='\033[0m'
            printf "${RED}${LOGO}${NC}\n"
            ;;
        *)
            printf "${LOGO}\n"
            ;;
        esac
    else
        printf "${LOGO}\n"
    fi

    printf "Amp - An agentic coding tool, in research preview from Sourcegraph\n\n"
}

# Package manager detection functions
has_homebrew() {
    has_cmd brew
}

is_homebrew_tapped() {
    if ! has_homebrew; then
        return 1
    fi
    brew tap | grep -q "^sourcegraph/amp-cli$" 2>/dev/null
}

install_homebrew() {
    local _homebrew_tap="sourcegraph/amp-cli"

    if ! has_homebrew; then
        err "Homebrew is not available"
    fi

    say "Installing Amp via Homebrew..."

    # Install tap if not already installed
    if ! is_homebrew_tapped; then
        verbose "Installing ${_homebrew_tap} tap..."
        run_cmd brew tap ${_homebrew_tap}
    else
        verbose "${_homebrew_tap} tap is already installed"
    fi

    # Install amp package
    verbose "Installing Amp package..."
    run_cmd brew install ${_homebrew_tap}/amp

    # Relink to ensure it's properly linked
    verbose "Relinking Amp package..."
    run_cmd brew link --overwrite amp
}

update_homebrew_tap() {
    if ! has_homebrew; then
        err "Homebrew is not available"
    fi

    if ! is_homebrew_tapped; then
        verbose "sourcegraph/amp-cli tap is not installed, installing first..."
        install_homebrew
        return 0
    fi

    say "Updating sourcegraph/amp-cli tap..."
    run_cmd brew tap --force-auto-update sourcegraph/amp-cli
}

has_nix() {
    has_cmd nix-env || has_cmd nix
}

install_nix_flake() {
    if ! has_cmd nix; then
        err "Nix is not available"
    fi

    say "Installing Amp via Nix flake..."
    verbose "Using nix profile install with experimental features..."

    run_cmd nix --extra-experimental-features nix-command --extra-experimental-features flakes profile install github:sourcegraph/amp-cli --no-write-lock-file
}

update_nix_flake() {
    if ! has_cmd nix; then
        err "Nix is not available"
    fi

    say "Updating Amp via Nix flake..."
    verbose "Using nix profile upgrade with experimental features..."

    run_cmd nix --extra-experimental-features nix-command --extra-experimental-features flakes profile upgrade github:sourcegraph/amp-cli --no-write-lock-file
}

install_aur() {
    if ! is_archlinux; then
        err "AUR installation is only available on Arch Linux"
    fi

    say "Installing Amp via AUR..."

    # Check for AUR helpers in order of preference
    if has_cmd yay; then
        verbose "Installing ampcode package via yay..."
        run_cmd yay -S --noconfirm ampcode
    elif has_cmd paru; then
        verbose "Installing ampcode package via paru..."
        run_cmd paru -S --noconfirm ampcode
    else
        err "No AUR helper found (yay or paru). Please install an AUR helper or install manually:
  git clone https://aur.archlinux.org/ampcode.git
  cd ampcode && makepkg -si"
    fi
}

# Install via APT repository (Debian/Ubuntu)
install_deb() {
    if ! is_debian && ! is_ubuntu; then
        err "APT installation is only available on Debian and Ubuntu"
    fi

    if ! has_cmd apt-get; then
        err "apt-get command not found"
    fi

    local _gpg_keyring="/usr/share/keyrings/amp-cli.gpg"
    local _sources_list="/etc/apt/sources.list.d/amp-cli.list"

    say "Installing Amp via APT repository..."

    # Download and install GPG key
    verbose "Downloading GPG key from $AMP_BINARY_ROOT/gpg/amp-cli.asc"
    run_cmd curl -fsSL "$AMP_BINARY_ROOT/gpg/amp-cli.asc" -o /tmp/amp-cli.asc

    verbose "Installing GPG key to $_gpg_keyring"
    run_cmd sudo gpg --dearmor --yes --output "$_gpg_keyring" /tmp/amp-cli.asc
    run_cmd rm -f /tmp/amp-cli.asc

    # Add repository to sources list
    verbose "Adding repository to $_sources_list"
    echo "deb [signed-by=$_gpg_keyring] $AMP_BINARY_ROOT/debian stable main" | run_cmd sudo tee "$_sources_list" > /dev/null

    # Update package index
    say "Updating package index..."
    run_cmd sudo apt-get update

    # Install Amp
    say "Installing Amp..."
    run_cmd sudo apt-get install -y amp
}

# Install via YUM/DNF repository (RHEL/Fedora/CentOS)
install_rpm() {
    if ! is_rhel && ! is_fedora && ! is_centos; then
        err "RPM installation is only available on RHEL, Fedora, and CentOS"
    fi

    local _package_manager=""
    if has_cmd dnf; then
        _package_manager="dnf"
    elif has_cmd yum; then
        _package_manager="yum"
    else
        err "Neither dnf nor yum package manager found"
    fi

    local _repo_file="/etc/yum.repos.d/amp-cli.repo"

    say "Installing Amp via RPM repository..."

    # Create repository configuration file
    verbose "Creating repository configuration at $_repo_file"
    cat <<EOF | run_cmd sudo tee "$_repo_file" > /dev/null
[amp-cli]
name=Amp CLI Repository
baseurl=$AMP_BINARY_ROOT/rpm
enabled=1
gpgcheck=1
gpgkey=$AMP_BINARY_ROOT/gpg/amp-cli.asc
EOF

    # Import GPG key
    say "Importing GPG key..."
    run_cmd sudo rpm --import "$AMP_BINARY_ROOT/gpg/amp-cli.asc"

    # Install Amp
    say "Installing Amp..."
    run_cmd sudo "$_package_manager" install -y amp
}

has_pnpm() {
    has_cmd pnpm
}

has_yarn() {
    has_cmd yarn
}

has_npm() {
    has_cmd npm
}

has_choco() {
    has_cmd choco
}

has_vscode() {
    has_cmd code
}

has_vscode_insiders() {
    has_cmd code-insiders
}

has_windsurf() {
    has_cmd windsurf
}

has_cursor() {
    has_cmd cursor
}

has_vscodium() {
    has_cmd codium
}

install_vscode_extension() {
    local _extension_id="sourcegraph.amp"
    local _installed_count=0

    say "Installing Amp extension for available editors..."

    # Install for VS Code
    if has_vscode; then
        say "Installing Amp extension for VS Code..."
        run_cmd code --install-extension "$_extension_id" --force
        _installed_count=$((_installed_count + 1))
    fi

    # Install for VS Code Insiders
    if has_vscode_insiders; then
        say "Installing Amp extension for VS Code Insiders..."
        run_cmd code-insiders --install-extension "$_extension_id" --force
        _installed_count=$((_installed_count + 1))
    fi

    # Install for Windsurf
    if has_windsurf; then
        say "Installing Amp extension for Windsurf..."
        run_cmd windsurf --install-extension "$_extension_id" --force
        _installed_count=$((_installed_count + 1))
    fi

    # Install for Cursor
    if has_cursor; then
        say "Installing Amp extension for Cursor..."
        run_cmd cursor --install-extension "$_extension_id" --force
        _installed_count=$((_installed_count + 1))
    fi

    # Install for VSCodium
    if has_vscodium; then
        say "Installing Amp extension for VSCodium..."
        run_cmd codium --install-extension "$_extension_id" --force
        _installed_count=$((_installed_count + 1))
    fi

    if [ "$_installed_count" -eq 0 ]; then
        say "No supported editors found (VS Code, VS Code Insiders, Windsurf, Cursor, or VSCodium)"
    else
        say "Amp extension installed for $_installed_count editor(s)"
    fi
}

update_vscode_extension() {
    local _extension_id="sourcegraph.amp"
    local _updated_count=0

    say "Updating Amp extension for available editors..."

    # Update for VS Code
    if has_vscode; then
        verbose "Updating Amp extension for VS Code..."
        run_cmd code --install-extension "$_extension_id" --force
        _updated_count=$((_updated_count + 1))
    fi

    # Update for VS Code Insiders
    if has_vscode_insiders; then
        verbose "Updating Amp extension for VS Code Insiders..."
        run_cmd code-insiders --install-extension "$_extension_id" --force
        _updated_count=$((_updated_count + 1))
    fi

    # Update for Windsurf
    if has_windsurf; then
        verbose "Updating Amp extension for Windsurf..."
        run_cmd windsurf --install-extension "$_extension_id" --force
        _updated_count=$((_updated_count + 1))
    fi

    # Update for Cursor
    if has_cursor; then
        verbose "Updating Amp extension for Cursor..."
        run_cmd cursor --install-extension "$_extension_id" --force
        _updated_count=$((_updated_count + 1))
    fi

    if [ "$_updated_count" -eq 0 ]; then
        say "No supported editors found (VS Code, VS Code Insiders, Windsurf, or Cursor)"
    else
        say "Amp extension updated for $_updated_count editor(s)"
    fi
}

install_cli() {
    say "Installing Amp CLI..."

    # Platform-specific installation logic with package manager priority
    if is_archlinux; then
        # Use AUR on Arch Linux
        verbose "Installing Amp CLI via AUR (Arch Linux detected)"
        install_aur
    elif is_debian || is_ubuntu; then
        # Use APT repository on Debian/Ubuntu
        verbose "Installing Amp CLI via APT repository (Debian/Ubuntu detected)"
        install_deb
    elif is_rhel || is_fedora || is_centos; then
        # Use RPM repository on RHEL/Fedora/CentOS
        verbose "Installing Amp CLI via RPM repository (RHEL/Fedora/CentOS detected)"
        install_rpm
    elif is_macos || [ "$(uname -s)" = "Linux" ]; then
        # Prefer Nix over Homebrew on macOS and Linux (non-package manager systems)
        if has_nix; then
            verbose "Installing Amp CLI via Nix (preferred on this platform)"
            install_nix_flake
        elif has_homebrew; then
            verbose "Installing Amp CLI via Homebrew (Nix not available)"
            install_homebrew
        else
            err "No supported package managers found (Nix or Homebrew). Please install Nix or Homebrew and try again"
        fi
    else
        err "Unsupported platform for automatic installation. Please install Amp CLI manually from https://github.com/sourcegraph/amp-cli/releases"
    fi

    say "Amp CLI installation completed successfully!"
}

# Operating system detection functions
is_archlinux() {
    [ -f /etc/arch-release ] || [ -f /etc/archlinux-release ]
}

is_nixos() {
    [ -f /etc/NIXOS ] || [ -f /etc/nixos/configuration.nix ]
}

is_debian() {
    [ -f /etc/debian_version ] || [ -f /etc/lsb-release ] && grep -q "Ubuntu\|Debian" /etc/lsb-release 2>/dev/null
}

is_ubuntu() {
    [ -f /etc/lsb-release ] && grep -q "Ubuntu" /etc/lsb-release 2>/dev/null
}

is_redhat() {
    [ -f /etc/redhat-release ] || [ -f /etc/rhel-release ] || ([ -f /etc/os-release ] && grep -q "Red Hat\|RHEL" /etc/os-release 2>/dev/null)
}

is_centos() {
    [ -f /etc/centos-release ] || ([ -f /etc/os-release ] && grep -q "CentOS" /etc/os-release 2>/dev/null)
}

is_rhel() {
    [ -f /etc/redhat-release ] || [ -f /etc/rhel-release ] || ([ -f /etc/os-release ] && grep -q "Red Hat\|RHEL" /etc/os-release 2>/dev/null)
}

is_fedora() {
    ([ -f /etc/os-release ] && grep -q "Fedora" /etc/os-release 2>/dev/null)
}

is_windows() {
    case "$(uname -s)" in
    CYGWIN* | MINGW* | MSYS*)
        return 0
        ;;
    *)
        return 1
        ;;
    esac
}

is_wsl() {
    # Check for WSL indicators
    [ -f /proc/version ] && grep -q "Microsoft\|WSL" /proc/version 2>/dev/null
}

is_macos() {
    [ "$(uname -s)" = "Darwin" ]
}

# Migration function to handle existing Node.js-based Amp installations
migrate() {
    verbose "Checking for existing Amp Node.js installation..."

    if ! has_cmd amp; then
        verbose "No existing amp found on PATH"
        return 0
    fi

    say "Found existing Amp Node.js installation"

    # Check which package manager installed amp
    local _package_manager=""
    local _confirm_msg=""
    local _uninstall_cmd=""

    # Check npm global packages
    local _npm_package_name="@sourcegraph/amp"
    if has_npm && npm list -g amp 2>/dev/null | grep -q ${_npm_package_name}; then
        _package_manager="npm"
        _confirm_msg="Found Amp installed via npm. Remove it?"
        _uninstall_cmd="npm uninstall -g ${_npm_package_name}"
    # Check pnpm global packages
    elif has_pnpm && pnpm list -g amp 2>/dev/null | grep -q "${_npm_package_name}"; then
        _package_manager="pnpm"
        _confirm_msg="Found Amp installed via pnpm. Remove it?"
        _uninstall_cmd="pnpm remove -g ${_npm_package_name}"
    # Check yarn global packages
    elif has_yarn && yarn global list 2>/dev/null | grep -q "${_npm_package_name}@"; then
        _package_manager="yarn"
        _confirm_msg="Found Amp installed via yarn. Remove it?"
        _uninstall_cmd="yarn global remove ${_npm_package_name}"
    else
        verbose "amp found but not installed via npm/pnpm/yarn, skipping migration"
        return 0
    fi

    verbose "Detected amp installed via $_package_manager"

    # Check for --no-confirm flag or environment variable
    local _no_confirm=""
    for arg in $SCRIPT_ARGS; do
        if [ "$arg" = "--no-confirm" ]; then
            _no_confirm="yes"
            break
        fi
    done

    if [ "${AMP_NO_CONFIRM-}" ]; then
        _no_confirm="yes"
    fi

    # Ask for confirmation unless --no-confirm is set
    if [ "$_no_confirm" != "yes" ]; then
        say "$_confirm_msg [y/N]"
        read -r _response
        case "$_response" in
        [yY] | [yY][eE][sS])
            ;;
        *)
            say "Skipping removal of existing amp installation"
            return 0
            ;;
        esac
    fi

    say "Removing existing amp installation via $_package_manager..."
    run_cmd $_uninstall_cmd

    # Verify removal (skip verification in dry-run mode)
    if [ "${AMP_DRY_RUN-}" ]; then
        say "Would remove existing amp installation"
    elif has_cmd amp; then
        err "Failed to remove existing amp installation"
    else
        say "Successfully removed existing amp installation"
    fi
}

main "$@" || exit 1
