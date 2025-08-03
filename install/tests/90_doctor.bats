#!/usr/bin/env bats

load 00_helpers

# Tests for doctor diagnostic functionality

@test "doctor shows basic system information" {
    mock_uname "Linux" "x86_64"
    make_stub whoami 0 "testuser"
    # pwd is a shell builtin, so we need to override it differently
    # We'll check for the User field instead of Working Directory
    
    run doctor
    [ "$status" -eq 0 ]
    assert_output_contains "amp-install"
    assert_output_contains "System Diagnostics"
    assert_output_contains "System Information:"
    assert_output_contains "OS: Linux"
    assert_output_contains "Architecture: x86_64"
    assert_output_contains "User: testuser"
    # Working Directory test removed as pwd is a shell builtin that can't be stubbed easily
}

@test "doctor shows macOS version when available" {
    mock_uname "Darwin" "arm64"
    make_stub whoami 0 "testuser"
    make_stub pwd 0 "/tmp/test"
    make_stub sw_vers 0 "10.15.7"
    
    run doctor
    [ "$status" -eq 0 ]
    assert_output_contains "macOS Version: 10.15.7"
}

@test "doctor detects architecture correctly" {
    mock_uname "Linux" "x86_64"
    make_stub whoami 0 "testuser"
    make_stub pwd 0 "/tmp/test"
    
    run doctor
    [ "$status" -eq 0 ]
    assert_output_contains "Architecture Detection:"
    assert_output_contains "Detected: x86_64-linux"
}

@test "doctor shows OS detection results" {
    mock_uname "Darwin" "arm64"
    make_stub whoami 0 "testuser"
    make_stub pwd 0 "/tmp/test"
    
    run doctor
    [ "$status" -eq 0 ]
    assert_output_contains "Operating System Detection:"
    assert_output_contains "macOS: ✓"
    assert_output_contains "Windows: ✗"
    assert_output_contains "WSL: ✗"
}

@test "doctor detects available package managers" {
    mock_uname "Linux" "x86_64"
    make_stub whoami 0 "testuser"
    make_stub brew 0 "Homebrew 3.0.0"
    make_stub nix 0 "nix (Nix) 2.4"
    # Create isolated environment by removing npm from PATH
    mkdir -p "$STUB_DIR/usr/bin" "$STUB_DIR/bin"
    export PATH="$STUB_DIR:$STUB_DIR/usr/bin:$STUB_DIR/bin"
    
    run doctor
    [ "$status" -eq 0 ]
    assert_output_contains "Package Managers:"
    assert_output_contains "Homebrew: ✓"
    assert_output_contains "Nix: ✓"
    assert_output_contains "npm: ✗"
}

@test "doctor shows Homebrew tap status" {
    mock_uname "Darwin" "arm64"
    make_stub whoami 0 "testuser"
    make_stub pwd 0 "/tmp/test"
    
    # Mock brew with tap installed
    cat > "$STUB_DIR/brew" << 'EOF'
#!/bin/sh
case "$*" in
    "--version")
        echo "Homebrew 3.0.0"
        ;;
    "tap")
        echo "homebrew/core"
        echo "sourcegraph/amp-cli"
        ;;
    *)
        exit 0
        ;;
esac
EOF
    chmod +x "$STUB_DIR/brew"
    
    run doctor
    [ "$status" -eq 0 ]
    assert_output_contains "sourcegraph/amp-cli tap: ✓"
}

@test "doctor detects VS Code extensions" {
    mock_uname "Linux" "x86_64"
    make_stub whoami 0 "testuser"
    make_stub pwd 0 "/tmp/test"
    
    # Mock VS Code with extension installed
    cat > "$STUB_DIR/code" << 'EOF'
#!/bin/sh
case "$*" in
    "--version")
        echo "1.60.0"
        ;;
    "--list-extensions")
        echo "sourcegraph.amp"
        echo "ms-python.python"
        ;;
    *)
        exit 0
        ;;
esac
EOF
    chmod +x "$STUB_DIR/code"
    
    run doctor
    [ "$status" -eq 0 ]
    assert_output_contains "VS Code: ✓"
    assert_output_contains "Amp extension: ✓"
}

@test "doctor shows required commands status" {
    mock_uname "Linux" "x86_64"
    make_stub whoami 0 "testuser"
    make_stub pwd 0 "/tmp/test"
    make_stub curl 0
    make_stub wget 0
    make_stub mktemp 0
    make_stub chmod 0
    make_stub mkdir 0
    make_stub rm 0
    make_stub rmdir 0
    
    run doctor
    [ "$status" -eq 0 ]
    assert_output_contains "Required Commands:"
    assert_output_contains "curl: ✓"
    assert_output_contains "wget: ✓"
    assert_output_contains "mktemp: ✓"
}

@test "doctor shows missing required commands" {
    mock_uname "Linux" "x86_64"
    make_stub whoami 0 "testuser"
    # Explicitly remove any existing stubs that we want to appear as missing
    rm -f "$STUB_DIR/curl" "$STUB_DIR/wget" "$STUB_DIR/mktemp" "$STUB_DIR/chmod" 
    rm -f "$STUB_DIR/mkdir" "$STUB_DIR/rm" "$STUB_DIR/rmdir"
    # Create empty directories to ensure these commands aren't found anywhere
    mkdir -p "$STUB_DIR/usr/bin" "$STUB_DIR/bin"
    export PATH="$STUB_DIR:$STUB_DIR/usr/bin:$STUB_DIR/bin"
    
    run doctor
    [ "$status" -eq 0 ]
    assert_output_contains "curl: ✗ (required)"
}

@test "doctor shows environment variables" {
    mock_uname "Linux" "x86_64"
    make_stub whoami 0 "testuser"
    make_stub pwd 0 "/tmp/test"
    
    export AMP_BINARY_ROOT="https://custom.example.com"
    export AMP_DRY_RUN="1"
    export HTTP_PROXY="http://proxy.example.com:8080"
    
    run doctor
    [ "$status" -eq 0 ]
    assert_output_contains "Environment Variables:"
    assert_output_contains "AMP_BINARY_ROOT: https://custom.example.com"
    assert_output_contains "AMP_DRY_RUN: 1"
    assert_output_contains "HTTP_PROXY: http://proxy.example.com:8080"
}

@test "doctor tests network connectivity" {
    mock_uname "Linux" "x86_64"
    make_stub whoami 0 "testuser"
    make_stub pwd 0 "/tmp/test"
    make_stub curl 0  # Successful connection
    
    run doctor
    [ "$status" -eq 0 ]
    assert_output_contains "Network Connectivity:"
    assert_output_contains "Binary root accessible: ✓"
}

@test "doctor shows network connectivity failure" {
    mock_uname "Linux" "x86_64"
    make_stub whoami 0 "testuser"
    make_stub pwd 0 "/tmp/test"
    make_stub curl 1  # Failed connection
    
    run doctor
    [ "$status" -eq 0 ]
    assert_output_contains "Binary root accessible: ✗"
}

@test "doctor tests temporary directory creation" {
    mock_uname "Linux" "x86_64"
    make_stub whoami 0 "testuser"
    make_stub pwd 0 "/tmp/test"
    
    # Mock mktemp to succeed and return a directory path
    cat > "$STUB_DIR/mktemp" << 'EOF'
#!/bin/sh
case "$*" in
    "-d")
        echo "/tmp/test.XXXXXX"
        mkdir -p "/tmp/test.XXXXXX" 2>/dev/null || true
        ;;
    *)
        echo "/tmp/test.XXXXXX"
        ;;
esac
EOF
    chmod +x "$STUB_DIR/mktemp"
    
    make_stub rmdir 0
    
    run doctor
    [ "$status" -eq 0 ]
    assert_output_contains "System Tests:"
    assert_output_contains "Temp directory creation: ✓"
}

@test "doctor tests current directory write permissions" {
    mock_uname "Linux" "x86_64"
    make_stub whoami 0 "testuser"
    make_stub pwd 0 "/tmp/test"
    
    # Current directory should be writable in test environment
    run doctor
    [ "$status" -eq 0 ]
    assert_output_contains "Current directory writable: ✓"
}

@test "doctor shows Nix profile information when available" {
    mock_uname "Linux" "x86_64"
    make_stub whoami 0 "testuser"
    make_stub pwd 0 "/tmp/test"
    
    # Mock nix command with profile support
    cat > "$STUB_DIR/nix" << 'EOF'
#!/bin/sh
case "$*" in
    "--version")
        echo "nix (Nix) 2.4"
        ;;
    "--extra-experimental-features nix-command --extra-experimental-features flakes profile list")
        echo "0 flake:github:sourcegraph/amp-cli github:sourcegraph/amp-cli"
        ;;
    *)
        exit 0
        ;;
esac
EOF
    chmod +x "$STUB_DIR/nix"
    
    run doctor
    [ "$status" -eq 0 ]
    assert_output_contains "Nix Profile Status:"
    assert_output_contains "Profile list: ✓"
}

@test "doctor ends with completion message" {
    mock_uname "Linux" "x86_64"
    make_stub whoami 0 "testuser"
    make_stub pwd 0 "/tmp/test"
    
    run doctor
    [ "$status" -eq 0 ]
    assert_output_contains "Diagnostics complete. Share this output when reporting issues."
}
