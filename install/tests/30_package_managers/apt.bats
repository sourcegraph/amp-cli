#!/usr/bin/env bats

load ../00_helpers

# Tests for APT installation functions

@test "install_deb fails on non-Debian/Ubuntu systems" {
    # Mock non-Debian system
    is_debian() { return 1; }
    is_ubuntu() { return 1; }
    export -f is_debian is_ubuntu
    
    run install_deb
    [ "$status" -eq 1 ]
    assert_output_contains "APT installation is only available on Debian and Ubuntu"
}

@test "install_deb fails when apt-get not available" {
    # Mock Debian system
    is_debian() { return 0; }
    is_ubuntu() { return 1; }
    export -f is_debian is_ubuntu
    
    run install_deb
    [ "$status" -eq 1 ]
    assert_output_contains "apt-get command not found"
}

@test "install_deb installs on Debian system" {
    # Mock Debian system
    is_debian() { return 0; }
    is_ubuntu() { return 1; }
    export -f is_debian is_ubuntu
    
    make_stub apt-get 0
    make_stub curl 0
    make_stub sudo 0
    make_stub gpg 0
    make_stub tee 0
    make_stub rm 0
    
    # Mock file creation for GPG key download
    touch "$BATS_TMPDIR/amp-cli.asc"
    
    export VERBOSE=1
    run install_deb
    [ "$status" -eq 0 ]
    assert_output_contains "Installing Amp via APT repository"
    assert_output_contains "Downloading GPG key"
    assert_output_contains "Installing GPG key"
    assert_output_contains "Adding repository"
    assert_output_contains "Updating package index"
    assert_output_contains "Installing Amp"
}

@test "install_deb installs on Ubuntu system" {
    # Mock Ubuntu system
    is_debian() { return 1; }
    is_ubuntu() { return 0; }
    export -f is_debian is_ubuntu
    
    make_stub apt-get 0
    make_stub curl 0
    make_stub sudo 0
    make_stub gpg 0
    make_stub tee 0
    make_stub rm 0
    
    touch "$BATS_TMPDIR/amp-cli.asc"
    
    run install_deb
    [ "$status" -eq 0 ]
    assert_output_contains "Installing Amp via APT repository"
}

@test "install_deb handles GPG key download failure" {
    # Mock Debian system
    is_debian() { return 0; }
    is_ubuntu() { return 1; }
    export -f is_debian is_ubuntu
    
    make_stub apt-get 0
    make_stub sudo 0
    make_stub gpg 0
    make_stub tee 0
    make_stub rm 0
    
    # Mock curl to fail
    make_stub curl 1
    
    run install_deb
    [ "$status" -eq 1 ]
    assert_output_contains "Failed to download GPG key"
}

@test "install_deb uses correct repository URL" {
    # Mock Debian system
    is_debian() { return 0; }
    is_ubuntu() { return 1; }
    export -f is_debian is_ubuntu
    
    make_logging_stub curl 0
    make_logging_stub sudo 0
    make_stub apt-get 0
    make_stub gpg 0
    make_stub tee 0
    make_stub rm 0
    
    touch "$BATS_TMPDIR/amp-cli.asc"
    
    export AMP_BINARY_ROOT="https://custom.example.com"
    run install_deb
    [ "$status" -eq 0 ]
    
    # Check that curl was called with the custom URL
    assert_stub_called curl "https://custom.example.com/gpg/amp-cli.asc"
}
