#!/usr/bin/env bash

# Common test helpers for install.sh test suite
# This file should be loaded by all test files: load helpers

# Load install.sh in test mode
load_install_script() {
    export AMP_INSTALL_TEST_MODE=1
    source "${BATS_TEST_DIRNAME}/../install.sh"
}

# Stub directory for fake commands
STUB_DIR=""

# Setup stub environment
setup_stubs() {
    STUB_DIR="$BATS_TMPDIR/stubs"
    mkdir -p "$STUB_DIR"
    # Store original PATH for restoration
    export ORIGINAL_PATH="$PATH"
    # Don't isolate PATH yet - we need real commands to create stubs
}

# Create a stub command that exits with specified code
# Usage: make_stub command_name [exit_code] [output]
make_stub() {
    local cmd="$1"
    local exit_code="${2:-0}"
    local output="${3:-}"
    
    cat > "$STUB_DIR/$cmd" << EOF
#!/bin/sh
${output:+echo "$output"}
exit $exit_code
EOF
    chmod +x "$STUB_DIR/$cmd"
}

# Create a stub that logs its arguments to a file
# Usage: make_logging_stub command_name [exit_code]
make_logging_stub() {
    local cmd="$1"
    local exit_code="${2:-0}"
    local log_file="$BATS_TMPDIR/${cmd}.log"
    
    cat > "$STUB_DIR/$cmd" << EOF
#!/bin/sh
echo "\$@" >> "$log_file"
exit $exit_code
EOF
    chmod +x "$STUB_DIR/$cmd"
}

# Check if a command was called with specific arguments
# Usage: assert_stub_called command_name "expected args"
assert_stub_called() {
    local cmd="$1"
    local expected_args="$2"
    local log_file="$BATS_TMPDIR/${cmd}.log"
    
    [ -f "$log_file" ] || {
        echo "Command $cmd was never called"
        return 1
    }
    
    if [ -n "$expected_args" ]; then
        grep -Fq "$expected_args" "$log_file" || {
            echo "Command $cmd was not called with expected arguments: $expected_args"
            echo "Actual calls:"
            cat "$log_file"
            return 1
        }
    fi
}

# Clean up stubs
teardown_stubs() {
    if [ -n "$STUB_DIR" ] && [ -d "$STUB_DIR" ]; then
        rm -rf "$STUB_DIR"
    fi
    # Restore original PATH if we saved it
    if [ -n "$ORIGINAL_PATH" ]; then
        export PATH="$ORIGINAL_PATH"
    fi
}

# Mock system utilities for consistent testing
mock_uname() {
    local os="${1:-Linux}"
    local arch="${2:-x86_64}"
    
    # Create uname that responds to -s and -m flags using printf
    printf '#!/bin/bash\ncase "$1" in\n  -s) echo "%s" ;;\n  -m) echo "%s" ;;\n  -o) echo "GNU/Linux" ;;\n  -r) echo "5.4.0-test" ;;\n  *) echo "%s" ;;\nesac\n' "$os" "$arch" "$os" > "$STUB_DIR/uname"
    chmod +x "$STUB_DIR/uname"
}

# Mock sysctl for macOS architecture detection
mock_sysctl() {
    local x86_64_support="${1:-0}"
    local arm64_support="${2:-0}"
    
    printf '#!/bin/bash\ncase "$*" in\n  "hw.optional.x86_64") echo "hw.optional.x86_64: %s" ;;\n  "hw.optional.arm64") echo "hw.optional.arm64: %s" ;;\n  *) exit 1 ;;\nesac\n' "$x86_64_support" "$arm64_support" > "$STUB_DIR/sysctl"
    chmod +x "$STUB_DIR/sysctl"
}

# Mock file system checks
mock_filesystem() {
    local tmpfs="$BATS_TMPDIR/mockfs"
    mkdir -p "$tmpfs/etc" "$tmpfs/proc"
    
    # Create OS detection files based on parameters
    case "${1:-}" in
        "arch")
            touch "$tmpfs/etc/arch-release"
            ;;
        "debian")
            echo "10.0" > "$tmpfs/etc/debian_version"
            ;;
        "ubuntu")
            cat > "$tmpfs/etc/lsb-release" << EOF
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=20.04
DISTRIB_CODENAME=focal
DISTRIB_DESCRIPTION="Ubuntu 20.04 LTS"
EOF
            ;;
        "nixos")
            touch "$tmpfs/etc/NIXOS"
            ;;
        "wsl")
            echo "Linux version 4.4.0-19041-Microsoft" > "$tmpfs/proc/version"
            ;;
    esac
    
    export MOCKFS_ROOT="$tmpfs"
}

# Assert output contains specific text
assert_output_contains() {
    local expected="$1"
    [[ "$output" == *"$expected"* ]] || {
        echo "Expected output to contain: $expected"
        echo "Actual output: $output"
        return 1
    }
}

# Assert output does not contain specific text
assert_output_not_contains() {
    local unexpected="$1"
    [[ "$output" != *"$unexpected"* ]] || {
        echo "Expected output to NOT contain: $unexpected"
        echo "Actual output: $output"
        return 1
    }
}

# Assert command was run (for dry-run testing)
assert_would_run() {
    local expected_cmd="$1"
    assert_output_contains "would run: $expected_cmd"
}

# Set up test environment
setup() {
    setup_stubs
    load_install_script
    
    # Don't isolate PATH completely - we need real commands for test infrastructure
    # Just prepend our stub directory so our stubs take precedence
    export PATH="$STUB_DIR:$ORIGINAL_PATH"
    
    # Default to dry-run mode for safety
    export AMP_DRY_RUN=1
    export VERBOSE=0
    export QUIET=0
    
    # Ensure RETVAL is available
    export RETVAL=""
}

# Clean up test environment
teardown() {
    teardown_stubs
    unset AMP_INSTALL_TEST_MODE AMP_DRY_RUN VERBOSE QUIET
}
