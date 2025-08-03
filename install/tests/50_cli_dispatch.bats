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
    
    make_stub nix 0
    make_stub brew 0
    
    # Mock install functions
    install_vscode_extension() { say "Installing Amp extension..."; }
    install_nix_flake() { say "Installing via Nix..."; }
    export -f install_vscode_extension install_nix_flake
    
    export VERBOSE=1
    run install_cli
    [ "$status" -eq 0 ]
    assert_output_contains "Installing Amp CLI"
    assert_output_contains "Installing Amp extension"
    assert_output_contains "Installing Amp CLI via Nix (preferred on this platform)"
    assert_output_contains "Installing via Nix"
    assert_output_contains "Amp CLI installation completed successfully"
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
    
    # Only Homebrew available
    make_stub brew 0
    
    # Mock install functions
    install_vscode_extension() { say "Installing Amp extension..."; }
    install_homebrew() { say "Installing via Homebrew..."; }
    export -f install_vscode_extension install_homebrew
    
    export VERBOSE=1
    run install_cli
    [ "$status" -eq 0 ]
    assert_output_contains "Installing Amp CLI via Homebrew (Nix not available)"
    assert_output_contains "Installing via Homebrew"
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
    assert_output_contains "Installing Amp CLI via AUR (Arch Linux detected)"
    assert_output_contains "Installing via AUR"
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
    assert_output_contains "Installing Amp CLI via APT repository (Debian/Ubuntu detected)"
    assert_output_contains "Installing via APT"
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
    assert_output_contains "Installing Amp CLI via RPM repository (RHEL/Fedora/CentOS detected)"
    assert_output_contains "Installing via RPM"
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
    assert_output_contains "Amp CLI is not yet available for Windows"
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
    
    # Mock install function
    install_vscode_extension() { say "Installing Amp extension..."; }
    export -f install_vscode_extension
    
    run install_cli
    [ "$status" -eq 1 ]
    assert_output_contains "No supported package managers found (Nix or Homebrew)"
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
    assert_output_contains "Unsupported platform for automatic installation"
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
    
    # Track order of calls
    install_vscode_extension() { echo "EXTENSION_FIRST"; }
    install_nix_flake() { echo "NIX_SECOND"; }
    export -f install_vscode_extension install_nix_flake
    
    run install_cli
    [ "$status" -eq 0 ]
    
    # Check that extension installation appears before CLI installation in output
    [[ "$output" =~ EXTENSION_FIRST.*NIX_SECOND ]]
}
