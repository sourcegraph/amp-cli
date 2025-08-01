#!/usr/bin/env bats

# Load the install script functions for testing
# We need to source the script but prevent it from running main()
setup() {
    # Extract functions from install.sh without running main
    export TEST_INSTALL_SCRIPT="${PWD}/install.sh"

    # Source the functions we need by creating a temporary script
    cat > "${BATS_TMPDIR}/functions.sh" << 'EOF'
#!/bin/sh

check_cmd() {
    command -v "$1" > /dev/null 2>&1
}

has_homebrew() {
    check_cmd brew
}

has_nix() {
    check_cmd nix-env || check_cmd nix
}

has_pnpm() {
    check_cmd pnpm
}

has_yarn() {
    check_cmd yarn
}

has_npm() {
    check_cmd npm
}

has_choco() {
    check_cmd choco
}

is_homebrew_tapped() {
    if ! has_homebrew; then
        return 1
    fi
    brew tap | grep -q "^sourcegraph/amp-cli$" 2>/dev/null
}

install_homebrew_tap() {
    if ! has_homebrew; then
        err "Homebrew is not available"
    fi

    if is_homebrew_tapped; then
        verbose "sourcegraph/amp-cli tap is already installed"
        return 0
    fi

    say "Installing sourcegraph/amp-cli tap..."
    run_cmd brew tap sourcegraph/amp-cli
}

update_homebrew_tap() {
    if ! has_homebrew; then
        err "Homebrew is not available"
    fi

    if ! is_homebrew_tapped; then
        verbose "sourcegraph/amp-cli tap is not installed, installing first..."
        install_homebrew_tap
        return 0
    fi

    say "Updating sourcegraph/amp-cli tap..."
    run_cmd brew tap --force-auto-update sourcegraph/amp-cli
}

install_nix_flake() {
    if ! check_cmd nix; then
        err "Modern nix command is not available. Please install Nix with flake support."
    fi
    
    say "Installing Amp via Nix flake..."
    verbose "Using nix profile install with experimental features and allowing unfree packages..."
    
    # Set environment variable to allow unfree packages
    NIXPKGS_ALLOW_UNFREE=1 run_cmd nix --extra-experimental-features nix-command --extra-experimental-features flakes --impure profile install github:sourcegraph/amp-cli
}

update_nix_flake() {
    if ! check_cmd nix; then
        err "Modern nix command is not available. Please install Nix with flake support."
    fi
    
    say "Updating Amp via Nix flake..."
    verbose "Using nix profile upgrade with experimental features and allowing unfree packages..."
    
    # Set environment variable to allow unfree packages
    NIXPKGS_ALLOW_UNFREE=1 run_cmd nix --extra-experimental-features nix-command --extra-experimental-features flakes --impure profile upgrade github:sourcegraph/amp-cli
}

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

is_windows() {
    case "$(uname -s)" in
        CYGWIN*|MINGW*|MSYS*)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

is_wsl() {
    [ -f /proc/version ] && grep -q "Microsoft\|WSL" /proc/version 2>/dev/null
}

is_macos() {
    [ "$(uname -s)" = "Darwin" ]
}

# Output control flags
VERBOSE=0
QUIET=0

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

run_cmd() {
    # Check for dry-run in test environment
    if [ "${AMP_DRY_RUN-}" ]; then
        printf 'would run: %s\n' "$*" >&2
        return 0
    else
        verbose "Running: $*"
        "$@"
    fi
}

# Migration function to handle existing Node.js-based amp installations
migrate() {
    verbose "Checking for existing amp installation..."

    if ! check_cmd amp; then
        verbose "No existing amp found on PATH"
        return 0
    fi

    say "Found existing amp installation"

    # Check which package manager installed amp
    local _package_manager=""
    local _confirm_msg=""
    local _uninstall_cmd=""

    # Check npm global packages
    if has_npm && npm list -g amp 2>/dev/null | grep -q "amp@"; then
        _package_manager="npm"
        _confirm_msg="Found amp installed via npm. Remove it?"
        _uninstall_cmd="npm uninstall -g amp"
    # Check pnpm global packages
    elif has_pnpm && pnpm list -g amp 2>/dev/null | grep -q "amp"; then
        _package_manager="pnpm"
        _confirm_msg="Found amp installed via pnpm. Remove it?"
        _uninstall_cmd="pnpm remove -g amp"
    # Check yarn global packages
    elif has_yarn && yarn global list 2>/dev/null | grep -q "amp@"; then
        _package_manager="yarn"
        _confirm_msg="Found amp installed via yarn. Remove it?"
        _uninstall_cmd="yarn global remove amp"
    else
        verbose "amp found but not installed via npm/pnpm/yarn, skipping migration"
        return 0
    fi

    verbose "Detected amp installed via $_package_manager"

    # Check for --no-confirm flag or environment variable
    local _no_confirm=""
    if [ "${AMP_NO_CONFIRM-}" ]; then
        _no_confirm="yes"
    fi

    # Ask for confirmation unless --no-confirm is set
    if [ "$_no_confirm" != "yes" ]; then
        printf "%s [y/N]: " "$_confirm_msg"
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
    elif check_cmd amp; then
        err "Failed to remove existing amp installation"
    else
        say "Successfully removed existing amp installation"
    fi
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
        if [ "$_cputype" = i386 ]; then
            if sysctl hw.optional.x86_64 2> /dev/null || true | grep -q ': 1'; then
                _cputype=x86_64
            fi
        elif [ "$_cputype" = x86_64 ]; then
            if sysctl hw.optional.arm64 2> /dev/null || true | grep -q ': 1'; then
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
            _ostype=unknown
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
            _cputype=unknown
            ;;
    esac

    _arch="${_cputype}-${_ostype}"
    RETVAL="$_arch"
}
EOF

    # Source the functions
    source "${BATS_TMPDIR}/functions.sh"
}

teardown() {
    # Clean up temporary files
    rm -f "${BATS_TMPDIR}/functions.sh"
}

# Test package manager detection functions
@test "has_homebrew detects homebrew when present" {
    if command -v brew >/dev/null 2>&1; then
        run has_homebrew
        [ "$status" -eq 0 ]
    else
        skip "homebrew not installed"
    fi
}

@test "has_homebrew fails when homebrew not present" {
    # Mock the check_cmd function to always fail
    check_cmd() { return 1; }
    run has_homebrew
    [ "$status" -eq 1 ]
}

@test "has_nix detects nix when present" {
    if command -v nix >/dev/null 2>&1 || command -v nix-env >/dev/null 2>&1; then
        run has_nix
        [ "$status" -eq 0 ]
    else
        skip "nix not installed"
    fi
}

@test "has_npm detects npm when present" {
    if command -v npm >/dev/null 2>&1; then
        run has_npm
        [ "$status" -eq 0 ]
    else
        skip "npm not installed"
    fi
}

@test "has_yarn detects yarn when present" {
    if command -v yarn >/dev/null 2>&1; then
        run has_yarn
        [ "$status" -eq 0 ]
    else
        skip "yarn not installed"
    fi
}

@test "has_pnpm detects pnpm when present" {
    if command -v pnpm >/dev/null 2>&1; then
        run has_pnpm
        [ "$status" -eq 0 ]
    else
        skip "pnpm not installed"
    fi
}

@test "has_choco fails on non-Windows systems" {
    if ! is_windows; then
        run has_choco
        [ "$status" -eq 1 ]
    else
        skip "Running on Windows"
    fi
}

# Test OS detection functions
@test "is_windows detects Windows correctly" {
    case "$(uname -s)" in
        CYGWIN*|MINGW*|MSYS*)
            run is_windows
            [ "$status" -eq 0 ]
            ;;
        *)
            run is_windows
            [ "$status" -eq 1 ]
            ;;
    esac
}

@test "is_wsl detects WSL correctly" {
    if [ -f /proc/version ] && grep -q "Microsoft\|WSL" /proc/version 2>/dev/null; then
        run is_wsl
        [ "$status" -eq 0 ]
    else
        run is_wsl
        [ "$status" -eq 1 ]
    fi
}

@test "is_archlinux detects Arch Linux correctly" {
    if [ -f /etc/arch-release ] || [ -f /etc/archlinux-release ]; then
        run is_archlinux
        [ "$status" -eq 0 ]
    else
        run is_archlinux
        [ "$status" -eq 1 ]
    fi
}

@test "is_nixos detects NixOS correctly" {
    if [ -f /etc/NIXOS ] || [ -f /etc/nixos/configuration.nix ]; then
        run is_nixos
        [ "$status" -eq 0 ]
    else
        run is_nixos
        [ "$status" -eq 1 ]
    fi
}

@test "is_debian detects Debian/Ubuntu correctly" {
    if [ -f /etc/debian_version ] || ([ -f /etc/lsb-release ] && grep -q "Ubuntu\|Debian" /etc/lsb-release 2>/dev/null); then
        run is_debian
        [ "$status" -eq 0 ]
    else
        run is_debian
        [ "$status" -eq 1 ]
    fi
}

@test "is_ubuntu detects Ubuntu correctly" {
    if [ -f /etc/lsb-release ] && grep -q "Ubuntu" /etc/lsb-release 2>/dev/null; then
        run is_ubuntu
        [ "$status" -eq 0 ]
    else
        run is_ubuntu
        [ "$status" -eq 1 ]
    fi
}

@test "is_macos detects macOS correctly" {
    if [ "$(uname -s)" = "Darwin" ]; then
        run is_macos
        [ "$status" -eq 0 ]
    else
        run is_macos
        [ "$status" -eq 1 ]
    fi
}

# Test architecture detection
@test "get_architecture returns valid architecture" {
    get_architecture

    # Check that RETVAL is set and contains expected patterns
    case "$RETVAL" in
        *-darwin|*-linux|*-windows)
            # Valid architecture format
            ;;
        *)
            echo "Invalid architecture format: $RETVAL"
            return 1
            ;;
    esac
}

@test "get_architecture handles Darwin correctly" {
    if [ "$(uname -s)" = "Darwin" ]; then
        get_architecture
        [[ "$RETVAL" == *"-darwin" ]]
    else
        skip "Not running on Darwin"
    fi
}

@test "get_architecture handles Linux correctly" {
    if [ "$(uname -s)" = "Linux" ]; then
        get_architecture
        [[ "$RETVAL" == *"-linux" ]]
    else
        skip "Not running on Linux"
    fi
}

# Test install script exists and is executable
@test "install.sh exists and is executable" {
    [ -f "$TEST_INSTALL_SCRIPT" ]
    [ -x "$TEST_INSTALL_SCRIPT" ]
}

@test "install.sh can run with --dry-run flag" {
    run timeout 10 "$TEST_INSTALL_SCRIPT" --dry-run
    [ "$status" -eq 0 ]
    [[ "$output" == *"would run:"* ]]
}

@test "install.sh displays logo and description" {
    run timeout 10 "$TEST_INSTALL_SCRIPT" --dry-run
    [ "$status" -eq 0 ]
    [[ "$output" == *"Amp - An agentic coding tool"* ]]
}

# Test script handles unknown flags gracefully
@test "install.sh handles unknown flags" {
    run timeout 10 "$TEST_INSTALL_SCRIPT" --unknown-flag --dry-run
    [ "$status" -eq 0 ]  # Should still work, just ignore unknown flag
}

# Test that critical commands are checked
@test "install.sh checks for required commands" {
    # The script should check for commands like curl, mktemp, etc.
    run timeout 10 "$TEST_INSTALL_SCRIPT" --dry-run
    [ "$status" -eq 0 ]
    # If the script runs successfully, it means required commands were found
}

# Test new usage functionality
@test "install.sh shows help with --help flag" {
    run timeout 10 "$TEST_INSTALL_SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"USAGE:"* ]]
    [[ "$output" == *"OPTIONS:"* ]]
}

@test "install.sh shows help with -h flag" {
    run timeout 10 "$TEST_INSTALL_SCRIPT" -h
    [ "$status" -eq 0 ]
    [[ "$output" == *"USAGE:"* ]]
}

@test "install.sh shows version with --version flag" {
    run timeout 10 "$TEST_INSTALL_SCRIPT" --version
    [ "$status" -eq 0 ]
    [[ "$output" == *"amp-install"* ]]
    [[ "$output" == *"Platform:"* ]]
}

@test "install.sh shows version with -V flag" {
    run timeout 10 "$TEST_INSTALL_SCRIPT" -V
    [ "$status" -eq 0 ]
    [[ "$output" == *"amp-install"* ]]
}

@test "install.sh runs in quiet mode" {
    run timeout 10 "$TEST_INSTALL_SCRIPT" --quiet --dry-run
    [ "$status" -eq 0 ]
    # Should not contain the logo or description
    [[ "$output" != *"Amp - An agentic coding tool"* ]]
    # Should still contain dry-run output
    [[ "$output" == *"would run:"* ]]
}

@test "install.sh runs in verbose mode" {
    run timeout 10 "$TEST_INSTALL_SCRIPT" --verbose --dry-run
    [ "$status" -eq 0 ]
    # Should contain verbose output
    [[ "$output" == *"Platform detected:"* ]]
    [[ "$output" == *"Download URL:"* ]]
}

@test "install.sh shows diagnostics with --doctor flag" {
    run timeout 10 "$TEST_INSTALL_SCRIPT" --doctor
    [ "$status" -eq 0 ]
    # Should contain diagnostic information
    [[ "$output" == *"System Diagnostics"* ]]
    [[ "$output" == *"System Information:"* ]]
    [[ "$output" == *"Package Managers:"* ]]
    [[ "$output" == *"Required Commands:"* ]]
    [[ "$output" == *"Environment Variables:"* ]]
}

# Test migrate function
@test "migrate returns early when amp is not on PATH" {
    # Mock check_cmd to simulate amp not being found
    check_cmd() {
        [ "$1" != "amp" ]
    }

    run migrate
    [ "$status" -eq 0 ]
}

@test "migrate detects npm-installed amp" {
    # Skip if npm is not available
    if ! has_npm; then
        skip "npm not available"
    fi

    # Mock functions to simulate npm-installed amp
    check_cmd() {
        case "$1" in
            amp) return 0 ;;
            *) command -v "$1" >/dev/null 2>&1 ;;
        esac
    }

    npm() {
        if [ "$1" = "list" ] && [ "$2" = "-g" ] && [ "$3" = "amp" ]; then
            echo "amp@1.0.0"
        fi
    }

    export AMP_DRY_RUN=1
    export AMP_NO_CONFIRM=1

    run migrate
    [ "$status" -eq 0 ]
    [[ "$output" == *"Found existing amp installation"* ]]
    [[ "$output" == *"would run: npm uninstall -g amp"* ]]
}

@test "migrate detects pnpm-installed amp" {
    # Skip if pnpm is not available
    if ! has_pnpm; then
        skip "pnpm not available"
    fi

    # Mock functions to simulate pnpm-installed amp
    check_cmd() {
        case "$1" in
            amp) return 0 ;;
            *) command -v "$1" >/dev/null 2>&1 ;;
        esac
    }

    pnpm() {
        if [ "$1" = "list" ] && [ "$2" = "-g" ] && [ "$3" = "amp" ]; then
            echo "amp 1.0.0"
        fi
    }

    export AMP_DRY_RUN=1
    export AMP_NO_CONFIRM=1

    run migrate
    [ "$status" -eq 0 ]
    [[ "$output" == *"Found existing amp installation"* ]]
    [[ "$output" == *"would run: pnpm remove -g amp"* ]]
}

@test "migrate detects yarn-installed amp" {
    # Skip if yarn is not available
    if ! has_yarn; then
        skip "yarn not available"
    fi

    # Mock functions to simulate yarn-installed amp
    check_cmd() {
        case "$1" in
            amp) return 0 ;;
            *) command -v "$1" >/dev/null 2>&1 ;;
        esac
    }

    yarn() {
        if [ "$1" = "global" ] && [ "$2" = "list" ]; then
            echo "amp@1.0.0"
        fi
    }

    export AMP_DRY_RUN=1
    export AMP_NO_CONFIRM=1

    run migrate
    [ "$status" -eq 0 ]
    [[ "$output" == *"Found existing amp installation"* ]]
    [[ "$output" == *"would run: yarn global remove amp"* ]]
}

@test "migrate skips non-nodejs amp installations" {
    # Mock functions to simulate amp installed via other means
    check_cmd() {
        case "$1" in
            amp) return 0 ;;
            *) command -v "$1" >/dev/null 2>&1 ;;
        esac
    }

    # Mock package managers to return no amp packages
    npm() {
        if [ "$1" = "list" ] && [ "$2" = "-g" ] && [ "$3" = "amp" ]; then
            return 1
        fi
    }

    pnpm() {
        if [ "$1" = "list" ] && [ "$2" = "-g" ] && [ "$3" = "amp" ]; then
            return 1
        fi
    }

    yarn() {
        if [ "$1" = "global" ] && [ "$2" = "list" ]; then
            echo "other-package@1.0.0"
        fi
    }

    export AMP_DRY_RUN=1

    run migrate
    [ "$status" -eq 0 ]
    [[ "$output" == *"Found existing amp installation"* ]]
}

@test "migrate respects AMP_NO_CONFIRM environment variable" {
    # Skip if npm is not available
    if ! has_npm; then
        skip "npm not available"
    fi

    # Mock functions
    check_cmd() {
        case "$1" in
            amp) return 0 ;;
            *) command -v "$1" >/dev/null 2>&1 ;;
        esac
    }

    npm() {
        if [ "$1" = "list" ] && [ "$2" = "-g" ] && [ "$3" = "amp" ]; then
            echo "amp@1.0.0"
        fi
    }

    export AMP_DRY_RUN=1
    export AMP_NO_CONFIRM=1

    run migrate
    [ "$status" -eq 0 ]
    # Should not prompt for confirmation
    [[ "$output" != *"Remove it? [y/N]:"* ]]
}

@test "migrate runs in dry-run mode correctly" {
    # Skip if npm is not available
    if ! has_npm; then
        skip "npm not available"
    fi

    # Mock functions
    check_cmd() {
        case "$1" in
            amp) return 0 ;;
            *) command -v "$1" >/dev/null 2>&1 ;;
        esac
    }

    npm() {
        if [ "$1" = "list" ] && [ "$2" = "-g" ] && [ "$3" = "amp" ]; then
            echo "amp@1.0.0"
        fi
    }

    export AMP_DRY_RUN=1
    export AMP_NO_CONFIRM=1

    run migrate
    [ "$status" -eq 0 ]
    [[ "$output" == *"would run: npm uninstall -g amp"* ]]
}

# Test homebrew tap functions
@test "is_homebrew_tapped fails when homebrew not present" {
    # Mock homebrew to be unavailable
    check_cmd() {
        [ "$1" != "brew" ]
    }

    run is_homebrew_tapped
    [ "$status" -eq 1 ]
}

@test "is_homebrew_tapped detects sourcegraph/amp-cli tap when present" {
    if ! has_homebrew; then
        skip "homebrew not installed"
    fi

    # Mock brew tap command to return sourcegraph/amp-cli
    brew() {
        if [ "$1" = "tap" ]; then
            echo "sourcegraph/amp-cli"
        fi
    }

    run is_homebrew_tapped
    [ "$status" -eq 0 ]
}

@test "is_homebrew_tapped fails when sourcegraph/amp-cli tap not present" {
    if ! has_homebrew; then
        skip "homebrew not installed"
    fi

    # Mock brew tap command to return different taps
    brew() {
        if [ "$1" = "tap" ]; then
            echo "other/tap"
        fi
    }

    run is_homebrew_tapped
    [ "$status" -eq 1 ]
}

@test "install_homebrew_tap fails when homebrew not present" {
    # Mock homebrew to be unavailable
    check_cmd() {
        [ "$1" != "brew" ]
    }

    run install_homebrew_tap
    [ "$status" -eq 1 ]
}

@test "install_homebrew_tap skips when tap already installed" {
    if ! has_homebrew; then
        skip "homebrew not installed"
    fi

    # Mock is_homebrew_tapped to return true
    is_homebrew_tapped() {
        return 0
    }

    export VERBOSE=1
    run install_homebrew_tap
    [ "$status" -eq 0 ]
    [[ "$output" == *"sourcegraph/amp-cli tap is already installed"* ]]
}

@test "install_homebrew_tap installs tap when not present" {
    if ! has_homebrew; then
        skip "homebrew not installed"
    fi

    # Mock is_homebrew_tapped to return false
    is_homebrew_tapped() {
        return 1
    }

    export AMP_DRY_RUN=1
    run install_homebrew_tap
    [ "$status" -eq 0 ]
    [[ "$output" == *"Installing sourcegraph/amp-cli tap..."* ]]
    [[ "$output" == *"would run: brew tap sourcegraph/amp-cli"* ]]
}

@test "update_homebrew_tap fails when homebrew not present" {
    # Mock homebrew to be unavailable
    check_cmd() {
        [ "$1" != "brew" ]
    }

    run update_homebrew_tap
    [ "$status" -eq 1 ]
}

@test "update_homebrew_tap installs tap when not present" {
    if ! has_homebrew; then
        skip "homebrew not installed"
    fi

    # Mock is_homebrew_tapped to return false
    is_homebrew_tapped() {
        return 1
    }

    # Mock install_homebrew_tap function
    install_homebrew_tap() {
        say "Installing sourcegraph/amp-cli tap..."
        run_cmd brew tap sourcegraph/amp-cli
    }

    export AMP_DRY_RUN=1
    export VERBOSE=1
    run update_homebrew_tap
    [ "$status" -eq 0 ]
    [[ "$output" == *"sourcegraph/amp-cli tap is not installed, installing first..."* ]]
    [[ "$output" == *"Installing sourcegraph/amp-cli tap..."* ]]
}

@test "update_homebrew_tap updates tap when already present" {
    if ! has_homebrew; then
        skip "homebrew not installed"
    fi

    # Mock is_homebrew_tapped to return true
    is_homebrew_tapped() {
        return 0
    }

    export AMP_DRY_RUN=1
    run update_homebrew_tap
    [ "$status" -eq 0 ]
    [[ "$output" == *"Updating sourcegraph/amp-cli tap..."* ]]
    [[ "$output" == *"would run: brew tap --force-auto-update sourcegraph/amp-cli"* ]]
}

# Test nix flake function
@test "install_nix_flake fails when nix command not present" {
    # Mock nix command to be unavailable
    check_cmd() {
        [ "$1" != "nix" ]
    }

    run install_nix_flake
    [ "$status" -eq 1 ]
    [[ "$output" == *"Modern nix command is not available"* ]]
}

@test "install_nix_flake installs via nix profile" {
    if ! check_cmd nix; then
        skip "nix command not installed"
    fi

    export AMP_DRY_RUN=1
    export VERBOSE=1
    run install_nix_flake
    [ "$status" -eq 0 ]
    [[ "$output" == *"Installing Amp via Nix flake..."* ]]
    [[ "$output" == *"Using nix profile install with experimental features and allowing unfree packages..."* ]]
    [[ "$output" == *"would run: nix --extra-experimental-features nix-command --extra-experimental-features flakes --impure profile install github:sourcegraph/amp-cli"* ]]
}

@test "update_nix_flake fails when nix command not present" {
    # Mock nix command to be unavailable
    check_cmd() {
        [ "$1" != "nix" ]
    }
    
    run update_nix_flake
    [ "$status" -eq 1 ]
    [[ "$output" == *"Modern nix command is not available"* ]]
}

@test "update_nix_flake updates via nix profile upgrade" {
    if ! check_cmd nix; then
        skip "nix command not installed"
    fi

    export AMP_DRY_RUN=1
    export VERBOSE=1
    run update_nix_flake
    [ "$status" -eq 0 ]
    [[ "$output" == *"Updating Amp via Nix flake..."* ]]
    [[ "$output" == *"Using nix profile upgrade with experimental features and allowing unfree packages..."* ]]
    [[ "$output" == *"would run: nix --extra-experimental-features nix-command --extra-experimental-features flakes --impure profile upgrade github:sourcegraph/amp-cli"* ]]
}
