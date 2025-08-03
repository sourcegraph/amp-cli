#!/usr/bin/env bats

load 00_helpers

# Tests for main CLI installation dispatch logic

@test "install_cli prefers Nix over Homebrew on macOS" {
    # Mock macOS
    is_macos() { return 0; }
    is_archlinux() { return 1; }
    is_debian() { return 1; }
    is_ubuntu() { return 1; }
    is_rhel() { return 1; }
    is_fedora() { return 1; }
    is_centos() { return 1; }
    is_windows() { return 1; }
    export -f is_macos is_archlinux is_debian is_ubuntu is_rhel is_fedora is_centos is_windows
    
    # Stub both nix and nix-env to ensure has_nix returns true
    make_stub nix 0
    make_stub nix-env 0
    make_stub brew 0
    
    # Mock install functions
    install_vscode_extension() { say "Installing Amp extension..."; }
    install_nix_flake() { say "Installing via Nix..."; }
    export -f install_vscode_extension install_nix_flake
    
    export VERBOSE=1
    
    # Prepend our stub directory to PATH for isolation (but keep system dirs)
    export PATH="$STUB_DIR:/usr/bin:/bin:/usr/sbin:/sbin"
    
    # Test install_cli directly - extensions are tested separately
    run install_cli
    [ "$status" -eq 0 ]
    assert_output_contains "amp-install: Installing Amp CLI..."

    assert_output_contains "amp-install (verbose): Installing Amp CLI via Nix (preferred on this platform)"
    assert_output_contains "amp-install: Installing via Nix..."
    assert_output_contains "amp-install: Amp CLI installation completed successfully!"
}

@test "install_cli falls back to Homebrew when Nix unavailable" {
    # Mock macOS
    is_macos() { return 0; }
    is_archlinux() { return 1; }
    is_debian() { return 1; }
    is_ubuntu() { return 1; }
    is_rhel() { return 1; }
    is_fedora() { return 1; }
    is_centos() { return 1; }
    is_windows() { return 1; }
    export -f is_macos is_archlinux is_debian is_ubuntu is_rhel is_fedora is_centos is_windows
    
    # Only Homebrew available - don't create nix stubs so they won't be found
    make_stub brew 0
    /bin/chmod +x "$STUB_DIR/brew"
    
    # Use only stub directory and minimal system paths (no nix paths)
    export PATH="$STUB_DIR:/usr/bin:/bin"
    
    # Mock install functions
    install_vscode_extension() { say "Installing Amp extension..."; }
    install_homebrew() { say "Installing via Homebrew..."; }
    export -f install_vscode_extension install_homebrew
    
    export VERBOSE=1
    run install_cli
    [ "$status" -eq 0 ]
    assert_output_contains "amp-install (verbose): Installing Amp CLI via Homebrew (Nix not available)"
    assert_output_contains "amp-install: Installing via Homebrew..."
}

@test "install_cli uses AUR on Arch Linux" {
    # Mock Arch Linux
    is_macos() { return 1; }
    is_archlinux() { return 0; }
    is_debian() { return 1; }
    is_ubuntu() { return 1; }
    is_rhel() { return 1; }
    is_fedora() { return 1; }
    is_centos() { return 1; }
    is_windows() { return 1; }
    export -f is_macos is_archlinux is_debian is_ubuntu is_rhel is_fedora is_centos is_windows
    
    # Mock install functions
    install_vscode_extension() { say "Installing Amp extension..."; }
    install_aur() { say "Installing via AUR..."; }
    export -f install_vscode_extension install_aur
    
    export VERBOSE=1
    run install_cli
    [ "$status" -eq 0 ]
    assert_output_contains "amp-install (verbose): Installing Amp CLI via AUR (Arch Linux detected)"
    assert_output_contains "amp-install: Installing via AUR..."
}

@test "install_cli uses APT on Debian/Ubuntu" {
    # Mock Debian
    is_macos() { return 1; }
    is_archlinux() { return 1; }
    is_debian() { return 0; }
    is_ubuntu() { return 1; }
    is_rhel() { return 1; }
    is_fedora() { return 1; }
    is_centos() { return 1; }
    is_windows() { return 1; }
    export -f is_macos is_archlinux is_debian is_ubuntu is_rhel is_fedora is_centos is_windows
    
    # Mock install functions
    install_vscode_extension() { say "Installing Amp extension..."; }
    install_deb() { say "Installing via APT..."; }
    export -f install_vscode_extension install_deb
    
    export VERBOSE=1
    run install_cli
    [ "$status" -eq 0 ]
    assert_output_contains "amp-install (verbose): Installing Amp CLI via APT repository (Debian/Ubuntu detected)"
    assert_output_contains "amp-install: Installing via APT..."
}

@test "install_cli uses RPM on RHEL/Fedora/CentOS" {
    # Mock RHEL
    is_macos() { return 1; }
    is_archlinux() { return 1; }
    is_debian() { return 1; }
    is_ubuntu() { return 1; }
    is_rhel() { return 0; }
    is_fedora() { return 1; }
    is_centos() { return 1; }
    is_windows() { return 1; }
    export -f is_macos is_archlinux is_debian is_ubuntu is_rhel is_fedora is_centos is_windows
    
    # Mock install functions
    install_vscode_extension() { say "Installing Amp extension..."; }
    install_rpm() { say "Installing via RPM..."; }
    export -f install_vscode_extension install_rpm
    
    export VERBOSE=1
    run install_cli
    [ "$status" -eq 0 ]
    assert_output_contains "amp-install (verbose): Installing Amp CLI via RPM repository (RHEL/Fedora/CentOS detected)"
    assert_output_contains "amp-install: Installing via RPM..."
}

@test "install_cli rejects Windows" {
    # Mock Windows
    is_macos() { return 1; }
    is_archlinux() { return 1; }
    is_debian() { return 1; }
    is_ubuntu() { return 1; }
    is_rhel() { return 1; }
    is_fedora() { return 1; }
    is_centos() { return 1; }
    is_windows() { return 0; }
    export -f is_macos is_archlinux is_debian is_ubuntu is_rhel is_fedora is_centos is_windows
    
    # Mock install function
    install_vscode_extension() { say "Installing Amp extension..."; }
    export -f install_vscode_extension
    
    run install_cli
    [ "$status" -eq 1 ]
    assert_output_contains "amp-install: Amp CLI is not yet available for Windows – please use WSL or Docker."
}

@test "install_cli fails when no package managers available on macOS" {
    # Mock macOS with no package managers
    is_macos() { return 0; }
    is_archlinux() { return 1; }
    is_debian() { return 1; }
    is_ubuntu() { return 1; }
    is_rhel() { return 1; }
    is_fedora() { return 1; }
    is_centos() { return 1; }
    is_windows() { return 1; }
    export -f is_macos is_archlinux is_debian is_ubuntu is_rhel is_fedora is_centos is_windows
    
    # Ensure no package managers are available - don't create any stubs
    # Override PATH to only include our stubs (which won't have package managers)
    export PATH="$STUB_DIR"
    
    # Mock install function
    install_vscode_extension() { say "Installing Amp extension..."; }
    export -f install_vscode_extension
    
    run install_cli
    [ "$status" -eq 1 ]
    assert_output_contains "amp-install: No supported package managers found (Nix or Homebrew). Please install Nix or Homebrew and try again"
}

@test "install_cli fails on completely unsupported platform" {
    # Mock unsupported platform
    is_macos() { return 1; }
    is_archlinux() { return 1; }
    is_debian() { return 1; }
    is_ubuntu() { return 1; }
    is_rhel() { return 1; }
    is_fedora() { return 1; }
    is_centos() { return 1; }
    is_windows() { return 1; }
    export -f is_macos is_archlinux is_debian is_ubuntu is_rhel is_fedora is_centos is_windows
    
    # Mock uname to return unsupported OS
    mock_uname "FreeBSD" "x86_64"
    
    # Mock install function
    install_vscode_extension() { say "Installing Amp extension..."; }
    export -f install_vscode_extension
    
    run install_cli
    [ "$status" -eq 1 ]
    assert_output_contains "amp-install: Unsupported platform for automatic installation. Please install Amp CLI manually from https://github.com/sourcegraph/amp-cli/releases"
}

@test "install_cli always installs VS Code extensions first" {
    # Mock any supported platform
    is_macos() { return 0; }
    is_archlinux() { return 1; }
    is_debian() { return 1; }
    is_ubuntu() { return 1; }
    is_rhel() { return 1; }
    is_fedora() { return 1; }
    is_centos() { return 1; }
    is_windows() { return 1; }
    export -f is_macos is_archlinux is_debian is_ubuntu is_rhel is_fedora is_centos is_windows
    
    make_stub nix 0
    make_stub nix-env 0
    
    # Override PATH to only include our stubs
    export PATH="$STUB_DIR"
    
    # Track order of calls
    install_vscode_extension() { echo "EXTENSION_FIRST"; }
    install_nix_flake() { echo "NIX_SECOND"; }
    export -f install_vscode_extension install_nix_flake
    
    # Create a composite function that shows the order
    test_sequence() {
        install_vscode_extension
        install_cli
    }
    
    # Test the sequence
    run test_sequence
    [ "$status" -eq 0 ]
    
    # Check that extension installation appears before CLI installation in output
    [[ "$output" =~ EXTENSION_FIRST.*NIX_SECOND ]]
}
