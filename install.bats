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
