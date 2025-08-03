#!/usr/bin/env bats

load 00_helpers

# Tests for migration functionality

@test "migrate skips when no amp command found" {
    export VERBOSE=1
    run migrate
    [ "$status" -eq 0 ]
    assert_output_contains "No existing amp found on PATH"
}

@test "migrate detects and removes npm installation" {
    # Mock amp command exists
    make_stub amp 0
    
    # Mock npm to return package info
    make_stub npm 0 "@sourcegraph/amp@1.0.0"
    
    # Mock the actual npm list command behavior
    cat > "$STUB_DIR/npm" << 'EOF'
#!/bin/sh
case "$*" in
    "list -g --depth=0")
        echo "@sourcegraph/amp@1.0.0"
        ;;
    "uninstall -g @sourcegraph/amp")
        echo "uninstalled @sourcegraph/amp"
        ;;
    *)
        exit 1
        ;;
esac
EOF
    chmod +x "$STUB_DIR/npm"
    
    export AMP_NO_CONFIRM=1
    export VERBOSE=1
    run migrate
    [ "$status" -eq 0 ]
    assert_output_contains "Found existing Amp Node.js installation"
    assert_output_contains "Detected amp installed via npm"
    assert_output_contains "would run: npm uninstall -g @sourcegraph/amp"
}

@test "migrate detects and removes pnpm installation" {
    make_stub amp 0
    
    # Mock pnpm behavior
    cat > "$STUB_DIR/pnpm" << 'EOF'
#!/bin/sh
case "$*" in
    "list -g --depth=0")
        echo "@sourcegraph/amp@1.0.0"
        ;;
    "remove -g @sourcegraph/amp")
        echo "removed @sourcegraph/amp"
        ;;
    *)
        exit 1
        ;;
esac
EOF
    chmod +x "$STUB_DIR/pnpm"
    
    # Mock npm to not have the package (so pnpm is checked)
    make_stub npm 1
    
    export AMP_NO_CONFIRM=1
    export VERBOSE=1
    run migrate
    [ "$status" -eq 0 ]
    assert_output_contains "Detected amp installed via pnpm"
    assert_output_contains "would run: pnpm remove -g @sourcegraph/amp"
}

@test "migrate detects and removes yarn installation" {
    make_stub amp 0
    
    # Mock yarn behavior
    cat > "$STUB_DIR/yarn" << 'EOF'
#!/bin/sh
case "$*" in
    "global list")
        echo "@sourcegraph/amp@1.0.0"
        ;;
    "global remove @sourcegraph/amp")
        echo "removed @sourcegraph/amp"
        ;;
    *)
        exit 1
        ;;
esac
EOF
    chmod +x "$STUB_DIR/yarn"
    
    # Mock npm and pnpm to not have the package
    make_stub npm 1
    make_stub pnpm 1
    
    export AMP_NO_CONFIRM=1
    export VERBOSE=1
    run migrate
    [ "$status" -eq 0 ]
    assert_output_contains "Detected amp installed via yarn"
    assert_output_contains "would run: yarn global remove @sourcegraph/amp"
}

@test "migrate skips when amp not installed via package managers" {
    make_stub amp 0
    make_stub npm 1  # npm list fails
    make_stub pnpm 1 # pnpm list fails
    make_stub yarn 1 # yarn list fails
    
    export VERBOSE=1
    run migrate
    [ "$status" -eq 0 ]
    assert_output_contains "amp found but not installed via npm/pnpm/yarn, skipping migration"
}

@test "migrate prompts for confirmation when no --no-confirm" {
    make_stub amp 0
    
    # Mock npm to return package info
    cat > "$STUB_DIR/npm" << 'EOF'
#!/bin/sh
case "$*" in
    "list -g --depth=0")
        echo "@sourcegraph/amp@1.0.0"
        ;;
    *)
        exit 1
        ;;
esac
EOF
    chmod +x "$STUB_DIR/npm"
    
    # Don't set AMP_NO_CONFIRM, simulate user saying "no"
    export VERBOSE=1
    
    # Mock read to return "n"
    run bash -c 'echo "n" | migrate'
    [ "$status" -eq 0 ]
    assert_output_contains "Found amp installed via npm. Remove it?"
    assert_output_contains "Skipping removal of existing amp installation"
}

@test "migrate handles AMP_NO_CONFIRM environment variable" {
    make_stub amp 0
    
    cat > "$STUB_DIR/npm" << 'EOF'
#!/bin/sh
case "$*" in
    "list -g --depth=0")
        echo "@sourcegraph/amp@1.0.0"
        ;;
    "uninstall -g @sourcegraph/amp")
        echo "uninstalled @sourcegraph/amp"
        ;;
    *)
        exit 1
        ;;
esac
EOF
    chmod +x "$STUB_DIR/npm"
    
    export AMP_NO_CONFIRM=1
    export VERBOSE=1
    run migrate
    [ "$status" -eq 0 ]
    assert_output_contains "would run: npm uninstall -g @sourcegraph/amp"
    # Should not contain prompt
    assert_output_not_contains "Remove it?"
}

@test "migrate verifies removal in non-dry-run mode" {
    make_stub amp 0
    
    cat > "$STUB_DIR/npm" << 'EOF'
#!/bin/sh
case "$*" in
    "list -g --depth=0")
        echo "@sourcegraph/amp@1.0.0"
        ;;
    "uninstall -g @sourcegraph/amp")
        echo "uninstalled @sourcegraph/amp"
        ;;
    *)
        exit 1
        ;;
esac
EOF
    chmod +x "$STUB_DIR/npm"
    
    # Remove amp command after "uninstall"
    cat > "$STUB_DIR/amp" << 'EOF'
#!/bin/sh
# This script will be "removed" by the uninstall process
exit 1
EOF
    chmod +x "$STUB_DIR/amp"
    
    export AMP_NO_CONFIRM=1
    unset AMP_DRY_RUN  # Run in real mode
    run migrate
    [ "$status" -eq 0 ]
    assert_output_contains "Successfully removed existing amp installation"
}

@test "migrate handles failed removal" {
    make_stub amp 0  # amp command still exists after "removal"
    
    cat > "$STUB_DIR/npm" << 'EOF'
#!/bin/sh
case "$*" in
    "list -g --depth=0")
        echo "@sourcegraph/amp@1.0.0"
        ;;
    "uninstall -g @sourcegraph/amp")
        echo "uninstall failed"
        exit 1
        ;;
    *)
        exit 1
        ;;
esac
EOF
    chmod +x "$STUB_DIR/npm"
    
    export AMP_NO_CONFIRM=1
    unset AMP_DRY_RUN  # Run in real mode
    run migrate
    [ "$status" -eq 1 ]
    assert_output_contains "Failed to remove existing amp installation"
}

@test "migrate reports dry-run status correctly" {
    make_stub amp 0
    
    cat > "$STUB_DIR/npm" << 'EOF'
#!/bin/sh
case "$*" in
    "list -g --depth=0")
        echo "@sourcegraph/amp@1.0.0"
        ;;
    *)
        exit 1
        ;;
esac
EOF
    chmod +x "$STUB_DIR/npm"
    
    export AMP_NO_CONFIRM=1
    export AMP_DRY_RUN=1
    run migrate
    [ "$status" -eq 0 ]
    assert_output_contains "Would remove existing amp installation"
}
