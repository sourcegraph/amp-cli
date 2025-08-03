#!/usr/bin/env bats

load ../00_helpers

# Tests for Nix installation functions

@test "install_nix_flake fails when nix not available" {
    run install_nix_flake
    [ "$status" -eq 1 ]
    assert_output_contains "Nix is not available"
}

@test "install_nix_flake runs correct command" {
    make_stub nix 0
    
    export VERBOSE=1
    run install_nix_flake
    [ "$status" -eq 0 ]
    assert_output_contains "Installing Amp via Nix flake"
    assert_output_contains "Using nix profile install with experimental features"
    assert_would_run "nix --extra-experimental-features nix-command --extra-experimental-features flakes profile install github:sourcegraph/amp-cli --no-write-lock-file"
}

@test "update_nix_flake fails when nix not available" {
    run update_nix_flake
    [ "$status" -eq 1 ]
    assert_output_contains "Nix is not available"
}

@test "update_nix_flake runs correct command" {
    make_stub nix 0
    
    export VERBOSE=1
    run update_nix_flake
    [ "$status" -eq 0 ]
    assert_output_contains "Updating Amp via Nix flake"
    assert_output_contains "Using nix profile upgrade with experimental features"
    assert_would_run "nix --extra-experimental-features nix-command --extra-experimental-features flakes profile upgrade github:sourcegraph/amp-cli --no-write-lock-file"
}

@test "has_nix detects modern nix command" {
    make_stub nix 0
    run has_nix
    [ "$status" -eq 0 ]
}

@test "has_nix detects legacy nix-env command" {
    make_stub nix-env 0
    run has_nix
    [ "$status" -eq 0 ]
}

@test "has_nix detects both nix and nix-env" {
    make_stub nix 0
    make_stub nix-env 0
    run has_nix
    [ "$status" -eq 0 ]
}

@test "has_nix fails when neither command available" {
    run has_nix
    [ "$status" -eq 1 ]
}
