#!/usr/bin/env bats

load ../00_helpers

# Tests for AUR installation functions

@test "install_aur fails when not on Arch Linux" {
    mock_uname "Linux" "x86_64"
    # Don't create arch-release file
    run install_aur
    [ "$status" -eq 1 ]
    assert_output_contains "AUR installation is only available on Arch Linux"
}

@test "install_aur installs via yay when available" {
    # Mock Arch Linux detection
    touch "$BATS_TMPDIR/arch-release"
    
    # Override is_archlinux to return true
    is_archlinux() { return 0; }
    export -f is_archlinux
    
    make_stub yay 0
    
    export VERBOSE=1
    run install_aur
    [ "$status" -eq 0 ]
    assert_output_contains "Installing Amp via AUR"
    assert_output_contains "Installing ampcode package via yay"
    assert_would_run "yay -S --noconfirm ampcode"
}

@test "install_aur installs via paru when yay unavailable" {
    # Mock Arch Linux detection
    is_archlinux() { return 0; }
    export -f is_archlinux
    
    # yay not available, paru available
    make_stub paru 0
    
    export VERBOSE=1
    run install_aur
    [ "$status" -eq 0 ]
    assert_output_contains "Installing Amp via AUR"
    assert_output_contains "Installing ampcode package via paru"
    assert_would_run "paru -S --noconfirm ampcode"
}

@test "install_aur fails when no AUR helper available" {
    # Mock Arch Linux detection
    is_archlinux() { return 0; }
    export -f is_archlinux
    
    # No AUR helpers available
    run install_aur
    [ "$status" -eq 1 ]
    assert_output_contains "Installing Amp via AUR"
    assert_output_contains "No AUR helper found (yay or paru)"
    assert_output_contains "Please install an AUR helper or install manually"
    assert_output_contains "git clone https://aur.archlinux.org/ampcode.git"
}

@test "install_aur prefers yay over paru" {
    # Mock Arch Linux detection
    is_archlinux() { return 0; }
    export -f is_archlinux
    
    # Both available, should prefer yay
    make_stub yay 0
    make_stub paru 0
    
    export VERBOSE=1
    run install_aur
    [ "$status" -eq 0 ]
    assert_output_contains "Installing ampcode package via yay"
    assert_output_not_contains "Installing ampcode package via paru"
}
