#!/usr/bin/env bats

load ../00_helpers

# Tests for Homebrew installation functions

@test "install_homebrew fails when brew not available" {
    run install_homebrew
    [ "$status" -eq 1 ]
    assert_output_contains "Homebrew is not available"
}

@test "install_homebrew installs tap when not present" {
    make_logging_stub brew 0
    
    # Mock is_homebrew_tapped to return false initially
    cat > "$STUB_DIR/brew" << 'EOF'
#!/bin/sh
echo "$@" >> /tmp/brew.log
case "$*" in
    "tap")
        # Return empty list (no taps)
        echo ""
        ;;
    "tap sourcegraph/amp-cli")
        echo "Tapping sourcegraph/amp-cli"
        ;;
    "install sourcegraph/amp-cli/amp")
        echo "Installing amp"
        ;;
    "link --overwrite amp")
        echo "Linking amp"
        ;;
    *)
        exit 0
        ;;
esac
EOF
    chmod +x "$STUB_DIR/brew"
    
    export VERBOSE=1
    run install_homebrew
    [ "$status" -eq 0 ]
    assert_output_contains "Installing Amp via Homebrew"
    assert_output_contains "Installing sourcegraph/amp-cli tap"
    assert_output_contains "would run: brew tap sourcegraph/amp-cli"
    assert_output_contains "would run: brew install sourcegraph/amp-cli/amp"
    assert_output_contains "would run: brew link --overwrite amp"
}

@test "install_homebrew skips tap installation when already present" {
    # Mock brew command that shows tap is already installed
    cat > "$STUB_DIR/brew" << 'EOF'
#!/bin/sh
case "$*" in
    "tap")
        echo "sourcegraph/amp-cli"
        ;;
    "install sourcegraph/amp-cli/amp")
        echo "Installing amp"
        ;;
    "link --overwrite amp")
        echo "Linking amp"
        ;;
    *)
        exit 0
        ;;
esac
EOF
    chmod +x "$STUB_DIR/brew"
    
    export VERBOSE=1
    run install_homebrew
    [ "$status" -eq 0 ]
    assert_output_contains "sourcegraph/amp-cli tap is already installed"
    assert_output_contains "would run: brew install sourcegraph/amp-cli/amp"
    assert_output_not_contains "would run: brew tap sourcegraph/amp-cli"
}

@test "update_homebrew_tap fails when brew not available" {
    run update_homebrew_tap
    [ "$status" -eq 1 ]
    assert_output_contains "Homebrew is not available"
}

@test "update_homebrew_tap installs when tap not present" {
    make_stub brew 0 ""  # Empty tap list
    
    export VERBOSE=1
    run update_homebrew_tap
    [ "$status" -eq 0 ]
    assert_output_contains "sourcegraph/amp-cli tap is not installed, installing first"
}

@test "update_homebrew_tap updates existing tap" {
    # Mock brew to show tap exists
    cat > "$STUB_DIR/brew" << 'EOF'
#!/bin/sh
case "$*" in
    "tap")
        echo "sourcegraph/amp-cli"
        ;;
    "tap --force-auto-update sourcegraph/amp-cli")
        echo "Updating tap"
        ;;
    *)
        exit 0
        ;;
esac
EOF
    chmod +x "$STUB_DIR/brew"
    
    export VERBOSE=1
    run update_homebrew_tap
    [ "$status" -eq 0 ]
    assert_output_contains "Updating sourcegraph/amp-cli tap"
    assert_output_contains "would run: brew tap --force-auto-update sourcegraph/amp-cli"
}

@test "is_homebrew_tapped detects tap correctly" {
    # Mock brew tap command
    cat > "$STUB_DIR/brew" << 'EOF'
#!/bin/sh
case "$*" in
    "tap")
        echo "homebrew/core"
        echo "sourcegraph/amp-cli"
        echo "homebrew/cask"
        ;;
    *)
        exit 0
        ;;
esac
EOF
    chmod +x "$STUB_DIR/brew"
    
    run is_homebrew_tapped
    [ "$status" -eq 0 ]
}

@test "is_homebrew_tapped fails when tap not found" {
    # Mock brew tap command without our tap
    cat > "$STUB_DIR/brew" << 'EOF'
#!/bin/sh
case "$*" in
    "tap")
        echo "homebrew/core"
        echo "homebrew/cask"
        ;;
    *)
        exit 0
        ;;
esac
EOF
    chmod +x "$STUB_DIR/brew"
    
    run is_homebrew_tapped
    [ "$status" -eq 1 ]
}

@test "is_homebrew_tapped fails when brew not available" {
    run is_homebrew_tapped
    [ "$status" -eq 1 ]
}
