#!/usr/bin/env bats

load ../00_helpers

# Tests for RPM installation functions

@test "install_rpm fails on non-RPM systems" {
    # Mock non-RPM system
    is_rhel() { return 1; }
    is_fedora() { return 1; }
    is_centos() { return 1; }
    export -f is_rhel is_fedora is_centos
    
    run install_rpm
    [ "$status" -eq 1 ]
    assert_output_contains "RPM installation is only available on RHEL, Fedora, and CentOS"
}

@test "install_rpm fails when no package manager available" {
    # Mock RHEL system
    is_rhel() { return 0; }
    is_fedora() { return 1; }
    is_centos() { return 1; }
    export -f is_rhel is_fedora is_centos
    
    run install_rpm
    [ "$status" -eq 1 ]
    assert_output_contains "Neither dnf nor yum package manager found"
}

@test "install_rpm prefers dnf over yum" {
    # Mock Fedora system
    is_rhel() { return 1; }
    is_fedora() { return 0; }
    is_centos() { return 1; }
    export -f is_rhel is_fedora is_centos
    
    make_stub dnf 0
    make_stub yum 0
    make_stub sudo 0
    make_stub rpm 0
    make_stub tee 0
    
    export VERBOSE=1
    run install_rpm
    [ "$status" -eq 0 ]
    assert_output_contains "Installing Amp via RPM repository"
    assert_would_run "sudo dnf install -y amp"
    assert_output_not_contains "sudo yum install"
}

@test "install_rpm falls back to yum when dnf unavailable" {
    # Mock CentOS system
    is_rhel() { return 1; }
    is_fedora() { return 1; }
    is_centos() { return 0; }
    export -f is_rhel is_fedora is_centos
    
    make_stub yum 0
    make_stub sudo 0
    make_stub rpm 0
    make_stub tee 0
    
    export VERBOSE=1
    run install_rpm
    [ "$status" -eq 0 ]
    assert_output_contains "Installing Amp via RPM repository"
    assert_would_run "sudo yum install -y amp"
}

@test "install_rpm creates repository configuration" {
    # Mock RHEL system
    is_rhel() { return 0; }
    is_fedora() { return 1; }
    is_centos() { return 1; }
    export -f is_rhel is_fedora is_centos
    
    make_stub dnf 0
    make_logging_stub sudo 0
    make_stub rpm 0
    make_stub tee 0
    
    export VERBOSE=1
    run install_rpm
    [ "$status" -eq 0 ]
    assert_output_contains "Creating repository configuration"
    assert_output_contains "Importing GPG key"
    assert_stub_called sudo "rpm --import"
}

@test "install_rpm uses custom binary root" {
    # Mock RHEL system
    is_rhel() { return 0; }
    is_fedora() { return 1; }
    is_centos() { return 1; }
    export -f is_rhel is_fedora is_centos
    
    make_stub dnf 0
    make_logging_stub sudo 0
    make_stub rpm 0
    make_stub tee 0
    
    export AMP_BINARY_ROOT="https://custom.example.com"
    run install_rpm
    [ "$status" -eq 0 ]
    
    # Check that rpm import was called with custom URL
    assert_stub_called sudo "rpm --import https://custom.example.com/gpg/amp-cli.asc"
}
