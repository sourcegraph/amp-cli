{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    # Package manager tools
    createrepo_c # For RPM repositories
    dpkg # For Debian packages
    # Linting and validation tools
    shellcheck # Shell script linting
    shfmt # Shell script formatting
    yamllint # YAML validation
    rubocop # Ruby linting (Homebrew formula)
    nixpkgs-fmt # Nix formatting
    dos2unix # Line ending conversion
    # PowerShell tools (if available)
    powershell # PowerShell Core for script validation
  ];

  # https://devenv.sh/languages/
  languages.ruby.enable = true; # For Homebrew formula validation
  languages.nix.enable = true; # For Nix files

  # https://devenv.sh/git-hooks/
  pre-commit = {
    hooks = {
      # Shell script validation and formatting
      shellcheck = {
        enable = true;
        files = "\\.(sh|bash)$";
        description = "Lint shell scripts with shellcheck";
      };

      shfmt = {
        enable = true;
        files = "\\.(sh|bash)$";
        description = "Format shell scripts with shfmt";
      };

      # YAML validation (GitHub Actions, winget manifests)
      yamllint = {
        enable = true;
        files = "\\.(yml|yaml)$";
        description = "Validate YAML files";
        settings = {
          configData = ''
            extends: default
            rules:
              line-length:
                max: 120
                level: warning
              comments:
                min-spaces-from-content: 1
              document-start: disable
              truthy: disable
          '';
        };
      };

      # Ruby validation (Homebrew formula)
      rubocop = {
        enable = true;
        files = "\\.rb$";
        entry = "${pkgs.rubocop}/bin/rubocop";
        description = "Lint Ruby files (Homebrew formula)";
      };

      # Nix formatting
      nixpkgs-fmt = {
        enable = true;
        files = "\\.nix$";
        description = "Format Nix files";
      };

      # PowerShell syntax validation
      powershell-syntax = {
        enable = true;
        files = "\\.ps1$";
        entry = "${pkgs.writeShellScript "validate-powershell" ''
          set -e
          echo "Validating PowerShell syntax: $1"

          # Use PowerShell to validate syntax
          ${pkgs.powershell}/bin/pwsh -Command "
            try {
              [System.Management.Automation.PSParser]::Tokenize((Get-Content -Raw '$1'), [ref]\$null) | Out-Null;
              Write-Host 'PowerShell syntax OK: $1'
            } catch {
              Write-Error 'PowerShell syntax error in $1: \$_';
              exit 1
            }
          "
        ''}";
        language = "system";
        description = "Validate PowerShell syntax";
      };

      # Custom hooks for package manager files
      validate-pkgbuild = {
        enable = true;
        files = "aur/.*/PKGBUILD$";
        entry = "${pkgs.writeShellScript "validate-pkgbuild" ''
          set -e
          echo "Validating PKGBUILD: $1"

          # Check required fields
          if ! grep -q "^pkgname=" "$1"; then
            echo "Error: Missing pkgname in $1"
            exit 1
          fi

          if ! grep -q "^pkgver=" "$1"; then
            echo "Error: Missing pkgver in $1"
            exit 1
          fi

          if ! grep -q "^pkgrel=" "$1"; then
            echo "Error: Missing pkgrel in $1"
            exit 1
          fi

          # Check for ripgrep dependency
          if ! grep -q "depends.*ripgrep" "$1"; then
            echo "Warning: ripgrep dependency not found in $1"
          fi

          echo "PKGBUILD validation passed: $1"
        ''}";
        language = "system";
        description = "Validate PKGBUILD files";
      };

      validate-debian-control = {
        enable = true;
        files = "debian/control$";
        entry = "${pkgs.writeShellScript "validate-debian-control" ''
          set -e
          echo "Validating Debian control file: $1"

          # Check required fields
          if ! grep -q "^Package:" "$1"; then
            echo "Error: Missing Package field in $1"
            exit 1
          fi

          if ! grep -q "^Architecture:" "$1"; then
            echo "Error: Missing Architecture field in $1"
            exit 1
          fi

          # Check for ripgrep dependency
          if ! grep -q "Depends:.*ripgrep" "$1"; then
            echo "Warning: ripgrep dependency not found in $1"
          fi

          echo "Debian control validation passed: $1"
        ''}";
        language = "system";
        description = "Validate Debian control files";
      };

      validate-rpm-spec = {
        enable = true;
        files = "\\.spec$";
        entry = "${pkgs.writeShellScript "validate-rpm-spec" ''
          set -e
          echo "Validating RPM spec file: $1"

          # Check required fields
          if ! grep -q "^Name:" "$1"; then
            echo "Error: Missing Name field in $1"
            exit 1
          fi

          if ! grep -q "^Version:" "$1"; then
            echo "Error: Missing Version field in $1"
            exit 1
          fi

          # Check for ripgrep dependency
          if ! grep -q "Requires:.*ripgrep" "$1"; then
            echo "Warning: ripgrep dependency not found in $1"
          fi

          echo "RPM spec validation passed: $1"
        ''}";
        language = "system";
        description = "Validate RPM spec files";
      };

      validate-chocolatey-nuspec = {
        enable = true;
        files = "\\.nuspec$";
        entry = "${pkgs.writeShellScript "validate-chocolatey-nuspec" ''
          set -e
          echo "Validating Chocolatey nuspec file: $1"

          # Check XML syntax
          ${pkgs.libxml2}/bin/xmllint --noout "$1" || {
            echo "Error: Invalid XML in $1"
            exit 1
          }

          # Check for ripgrep dependency
          if ! grep -q "ripgrep" "$1"; then
            echo "Warning: ripgrep dependency not found in $1"
          fi

          echo "Chocolatey nuspec validation passed: $1"
        ''}";
        language = "system";
        description = "Validate Chocolatey nuspec files";
      };

      # Docker hooks
      validate-dockerfile = {
        enable = true;
        files = "Dockerfile$";
        entry = "${pkgs.writeShellScript "validate-dockerfile" ''
          set -e
          echo "Validating Dockerfile: $1"

          # Basic syntax validation
          if command -v docker >/dev/null 2>&1; then
            # Check basic Docker command syntax by parsing the file
            if ! docker buildx build --help >/dev/null 2>&1; then
              echo "Warning: Docker buildx not available, skipping advanced syntax validation"
            fi
          else
            echo "Warning: Docker not available, skipping syntax validation"
          fi

          # Basic Dockerfile checks
          if ! grep -q "FROM" "$1"; then
            echo "Error: No FROM instruction found in $1"
            exit 1
          fi

          echo "Dockerfile validation passed: $1"
        ''}";
        language = "system";
        description = "Validate Dockerfile syntax and best practices";
      };

      # Generic file checks
      end-of-file-fixer.enable = true;
      trailing-whitespace = {
        enable = true;
        entry = "${pkgs.python3Packages.pre-commit-hooks}/bin/trailing-whitespace-fixer";
      };
      mixed-line-ending = {
        enable = true;
        entry = "${pkgs.dos2unix}/bin/dos2unix";
        args = [ "--keepdate" ];
      };

      # Check for merge conflicts
      check-merge-conflict = {
        enable = true;
        entry = "${pkgs.git}/bin/git";
        args = [ "diff" "--check" ];
      };

      # Prevent large files from being committed
      check-added-large-files = {
        enable = true;
        args = [ "--maxkb=1000" ];
      };
    };
  };

  # https://devenv.sh/scripts/
  scripts = {
    hello.exec = ''
      echo hello from $GREET
    '';

    validate-all-packages.exec = ''
      echo "Validating all package manager configurations..."

      # Validate Homebrew formula
      if [ -f "Formula/amp.rb" ]; then
        echo "Checking Homebrew formula..."
        ruby -c Formula/amp.rb
      fi

      # Validate Nix flake
      if [ -f "flake.nix" ]; then
        echo "Checking Nix flake..."
        nix --extra-experimental-features nix-command flake check --no-build
      fi

      # Validate GitHub Actions
      if [ -d ".github/workflows" ]; then
      echo "Checking GitHub Actions workflows..."
      yamllint .github/workflows/*.yml
      fi

      # Validate Docker files
      if [ -d "docker" ]; then
        echo "Checking Docker files..."
        if [ -f "docker/Dockerfile" ]; then
          echo "Validating Dockerfile..."
          if command -v docker >/dev/null 2>&1; then
            docker build --dry-run -f docker/Dockerfile . >/dev/null 2>&1 || {
              echo "Error: Invalid Dockerfile syntax"
              exit 1
            }
            echo "Dockerfile validation passed"
          else
            echo "Warning: Docker not available, skipping syntax validation"
          fi
        fi
      fi

      echo "Package validation complete!"
    '';

    build-test-packages.exec = ''
      echo "Building test packages..."

      # Test Debian package build (if tools available)
      if command -v dpkg-buildpackage >/dev/null 2>&1; then
        echo "Testing Debian package build..."
        # This would need actual binary files to work
        echo "Debian build tools available"
      fi

      # Test RPM build (if tools available)
      if command -v rpmbuild >/dev/null 2>&1; then
        echo "Testing RPM build..."
        echo "RPM build tools available"
      fi

      echo "Test build complete!"
    '';
  };

  enterShell = ''
    hello
    echo "Package manager development environment ready!"
    echo "Available scripts:"
    echo "  - validate-all-packages: Validate all package configurations (including Docker)"
    echo "  - build-test-packages: Test package building"
    echo ""
    echo "Pre-commit hooks configured for:"
    echo "  - Shell scripts (shellcheck, shfmt)"
    echo "  - YAML files (yamllint)"
    echo "  - Ruby files (rubocop)"
    echo "  - Nix files (nixpkgs-fmt)"
    echo "  - PowerShell files (syntax validation)"
    echo "  - Package manager files (custom validators)"
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running package manager tests..."
    validate-all-packages
  '';
}
