# AGENT.md

This file contains important information for AI agents and developers working on the amp-cli repository.

## Project Overview

**amp-cli** is an agentic coding tool from Sourcegraph. This repository manages package configurations, installation scripts, and distribution across multiple package managers and platforms.

## Repository Structure

```
amp-cli/
├── install.sh               # Main installation script (POSIX shell)
├── install.bats             # BATS test suite for install.sh
├── Formula/                 # Homebrew formula
├── aur/                     # Arch User Repository packages
├── chocolatey/              # Chocolatey package configuration
├── debian/                  # Debian/Ubuntu package files
├── docker/                  # Docker configurations
├── rpm/                     # RPM package configurations
├── repository/              # Package repository files
├── scripts/                 # Utility scripts
├── devenv.nix               # Development environment
└── flake.nix                # Nix flake configuration
```

## Key Files

### Core Installation Scripts
- **`install.sh`** - Main POSIX shell installation script with comprehensive platform detection
- **`install.bats`** - Test suite covering all installation script functionality

### Package Manager Configurations
- **`Formula/amp.rb`** - Homebrew formula for macOS/Linux
- **`aur/*/PKGBUILD`** - Arch Linux package builds
- **`debian/control`** - Debian package metadata
- **`chocolatey/*.nuspec`** - Chocolatey package specification
- **`flake.nix`** - Nix package configuration

## Development Environment

This project uses **devenv** for development environment management.

### Setup
```bash
# Enter development environment
devenv shell

# Or use direnv (auto-loads when entering directory)
direnv allow
```

### Available Scripts
- **`validate-all-packages`** - Validate all package configurations
- **`build-test-packages`** - Test package building
- **`test-install-script`** - Run BATS tests for install script

## Install Script (install.sh)

### Usage
```bash
# Development testing
./install.sh --dry-run --verbose
./install.sh --help
./install.sh --version
./install.sh --doctor
```

### Environment Variables
- `AMP_BINARY_ROOT` - Override binary download URL root
- `AMP_OVERRIDE_URL` - Override complete binary download URL
- `AMP_DRY_RUN` - Enable dry-run mode
- `AMP_NO_CONFIRM` - Skip confirmation prompts
- `HTTP_PROXY` - HTTP proxy server URL
- `HTTPS_PROXY` - HTTPS proxy server URL
- `NO_PROXY` - Comma-separated list of hosts to bypass proxy

## Testing

### BATS Test Suite
Run the comprehensive test suite:
```bash
bats install.bats
# or
test-install-script
```

### Manual Testing Commands
```bash
# Test platform detection
./install.sh --dry-run --verbose

# Test quiet mode
./install.sh --quiet --dry-run

# Test help system
./install.sh --help
./install.sh --version
```

## Code Style & Conventions

### Shell Scripts
- **POSIX compliance** - Works across different shells (bash, dash, zsh)
- **shellcheck clean** - All scripts pass shellcheck linting
- **Consistent error handling** - Use `err()` function for errors
- **Verbose logging** - Use `verbose()` and `say()` functions
- **Set strict mode** - Always use `set -u`

### Function Naming
- Detection functions: `has_*()`, `is_*()`
- Utility functions: `run_cmd()`, `ensure()`, `check_cmd()`
- Output functions: `say()`, `verbose()`, `err()`

### Variable Conventions
- Global flags: `VERBOSE`, `QUIET`, `SCRIPT_VERSION`
- Local variables: Use `local` keyword, prefix with `_` (e.g., `_arch`)
- Environment variables: `AMP_*` prefix

## Pre-commit Hooks

The repository includes comprehensive validation:
- **shellcheck** - Shell script linting
- **shfmt** - Shell script formatting
- **yamllint** - YAML validation
- **rubocop** - Ruby linting (Homebrew formula)
- **nixpkgs-fmt** - Nix file formatting
- **Custom validators** - Package-specific validation

## Build & Release Process

### Validation Workflow
1. Run all pre-commit hooks
2. Execute BATS test suite

## Common Tasks

### Adding New Platform Support
1. Update `get_architecture()` in install.sh
2. Add detection functions (`is_*()`)
3. Update package configurations
4. Add test cases to install.bats
5. Update documentation

### Debugging Installation Issues
1. **Run diagnostics first**: `./install.sh --doctor`
2. Use `--verbose --dry-run` for detailed output
3. Check platform detection: `get_architecture()`
4. Verify package manager detection functions
5. Test with different shells: bash, dash, zsh

### Package Manager Integration
1. Add detection function (`has_packagemanager()`)
2. Create package configuration files
3. Add validation hooks in devenv.nix
4. Update install script logic if needed
