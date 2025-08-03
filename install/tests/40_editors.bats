#!/usr/bin/env bats

load 00_helpers

# Tests for VS Code extension installation

@test "install_vscode_extension handles no editors found" {
    # Remove any existing editor stubs to ensure no editors are found
    rm -f "$STUB_DIR/code" "$STUB_DIR/code-insiders" "$STUB_DIR/windsurf" "$STUB_DIR/cursor" "$STUB_DIR/codium"
    
    run install_vscode_extension
    [ "$status" -eq 0 ]
    assert_output_contains "Installing Amp extension for available editors"
    assert_output_contains "No supported editors found"
}

@test "install_vscode_extension installs for VS Code" {
    # Remove any existing editor stubs and only create the one we want
    rm -f "$STUB_DIR/code" "$STUB_DIR/code-insiders" "$STUB_DIR/windsurf" "$STUB_DIR/cursor" "$STUB_DIR/codium"
    make_stub code 0
    
    export VERBOSE=1
    run install_vscode_extension
    [ "$status" -eq 0 ]
    assert_output_contains "Installing Amp extension for VS Code"
    assert_would_run "code --install-extension sourcegraph.amp --force"
    assert_output_contains "Amp extension installed for 1 editor(s)"
}

@test "install_vscode_extension installs for VS Code Insiders" {
    # Clean stub directory and only create the one we want
    rm -rf "$STUB_DIR"
    mkdir -p "$STUB_DIR"
    make_stub code-insiders 0
    
    export VERBOSE=1
    run install_vscode_extension
    [ "$status" -eq 0 ]
    assert_output_contains "Installing Amp extension for VS Code Insiders"
    assert_would_run "code-insiders --install-extension sourcegraph.amp --force"
}

@test "install_vscode_extension installs for Windsurf" {
    make_stub windsurf 0
    
    export VERBOSE=1
    run install_vscode_extension
    [ "$status" -eq 0 ]
    assert_output_contains "Installing Amp extension for Windsurf"
    assert_would_run "windsurf --install-extension sourcegraph.amp --force"
}

@test "install_vscode_extension installs for Cursor" {
    make_stub cursor 0
    
    export VERBOSE=1
    run install_vscode_extension
    [ "$status" -eq 0 ]
    assert_output_contains "Installing Amp extension for Cursor"
    assert_would_run "cursor --install-extension sourcegraph.amp --force"
}

@test "install_vscode_extension installs for VSCodium" {
    make_stub codium 0
    
    export VERBOSE=1
    run install_vscode_extension
    [ "$status" -eq 0 ]
    assert_output_contains "Installing Amp extension for VSCodium"
    assert_would_run "codium --install-extension sourcegraph.amp --force"
}

@test "install_vscode_extension installs for multiple editors" {
    # Completely clean the stub directory and only create the ones we want
    rm -rf "$STUB_DIR"
    mkdir -p "$STUB_DIR"
    make_stub code 0
    make_stub windsurf 0
    make_stub cursor 0
    
    export VERBOSE=1
    run install_vscode_extension
    [ "$status" -eq 0 ]
    assert_output_contains "Installing Amp extension for VS Code"
    assert_output_contains "Installing Amp extension for Windsurf"
    assert_output_contains "Installing Amp extension for Cursor"
    assert_output_contains "Amp extension installed for 3 editor(s)"
}

@test "update_vscode_extension handles no editors found" {
    # Remove any existing editor stubs to ensure no editors are found
    rm -f "$STUB_DIR/code" "$STUB_DIR/code-insiders" "$STUB_DIR/windsurf" "$STUB_DIR/cursor" "$STUB_DIR/codium"
    
    run update_vscode_extension
    [ "$status" -eq 0 ]
    assert_output_contains "Updating Amp extension for available editors"
    assert_output_contains "No supported editors found"
}

@test "update_vscode_extension updates for VS Code" {
    # Remove any existing editor stubs and only create the one we want
    rm -f "$STUB_DIR/code" "$STUB_DIR/code-insiders" "$STUB_DIR/windsurf" "$STUB_DIR/cursor" "$STUB_DIR/codium"
    make_stub code 0
    
    export VERBOSE=1
    run update_vscode_extension
    [ "$status" -eq 0 ]
    assert_output_contains "Updating Amp extension for VS Code"
    assert_would_run "code --install-extension sourcegraph.amp --force"
    assert_output_contains "Amp extension updated for 1 editor(s)"
}

@test "update_vscode_extension updates for multiple editors" {
    # Remove any existing editor stubs and only create the ones we want
    rm -f "$STUB_DIR/code" "$STUB_DIR/code-insiders" "$STUB_DIR/windsurf" "$STUB_DIR/cursor" "$STUB_DIR/codium"
    make_stub code 0
    make_stub code-insiders 0
    make_stub windsurf 0
    make_stub cursor 0
    
    export VERBOSE=1
    run update_vscode_extension
    [ "$status" -eq 0 ]
    assert_output_contains "Updating Amp extension for VS Code"
    assert_output_contains "Updating Amp extension for VS Code Insiders"
    assert_output_contains "Updating Amp extension for Windsurf"
    assert_output_contains "Updating Amp extension for Cursor"
    assert_output_contains "Amp extension updated for 4 editor(s)"
}

@test "editor detection functions work correctly" {
    # Remove any existing editor stubs and create fresh ones
    rm -f "$STUB_DIR/code" "$STUB_DIR/code-insiders" "$STUB_DIR/windsurf" "$STUB_DIR/cursor" "$STUB_DIR/codium"
    make_stub code 0
    make_stub code-insiders 0
    make_stub windsurf 0
    make_stub cursor 0
    make_stub codium 0
    
    run has_vscode
    [ "$status" -eq 0 ]
    
    run has_vscode_insiders
    [ "$status" -eq 0 ]
    
    run has_windsurf
    [ "$status" -eq 0 ]
    
    run has_cursor
    [ "$status" -eq 0 ]
    
    run has_vscodium
    [ "$status" -eq 0 ]
}

@test "editor detection functions fail when editors not available" {
    # Remove any existing editor stubs to ensure no editors are found
    rm -f "$STUB_DIR/code" "$STUB_DIR/code-insiders" "$STUB_DIR/windsurf" "$STUB_DIR/cursor" "$STUB_DIR/codium"
    
    run has_vscode
    [ "$status" -eq 1 ]
    
    run has_vscode_insiders
    [ "$status" -eq 1 ]
    
    run has_windsurf
    [ "$status" -eq 1 ]
    
    run has_cursor
    [ "$status" -eq 1 ]
    
    run has_vscodium
    [ "$status" -eq 1 ]
}
