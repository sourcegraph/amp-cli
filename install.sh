#!/bin/sh
# shellcheck shell=dash

# If you need an offline install, or you'd prefer to run the binary directly, head to
# https://github.com/sourcegraph/amp-cli/releases then pick the version and platform
# most appropriate for your deployment target.
#
# This is just a little script that selects and downloads the right `amp`. It does
# platform detection, downloads the installer, and runs it; that's it.
#

# This script is based off https://github.com/rust-lang/rustup/blob/f8d7b3baba7a63237cb2b82ef49a68a37dd0633c/rustup-init.sh

set -u

# Script version
SCRIPT_VERSION="1.0.0"

# If AMP_BINARY_ROOT is unset or empty, default it.
AMP_BINARY_ROOT="${AMP_BINARY_ROOT:-https://packages.ampcode.com/binaries}"

# Store script arguments for dry-run detection
SCRIPT_ARGS="$*"

# Output control flags
VERBOSE=0
QUIET=0

LOGO="
                 ..
                ,cc:;;,'...
                .,;::cclllc:;,'.
           .''...   ....',;:clc'
          .;lllcc:;,,'...  .,cl:.
           ...',;:clllllc;. .:lc'
      ,:;,,....   ....,cll'  ,cl:.
     .,::clllcc:;,'.   'cl:. .:lc'
        ....,;cllll:,. .:ll,  'cl:.
            .':lllllc,  'cl:. ....
           ':ll:,;cll:. .;ll,
         .:clc,. .;lll,  'cc,.
        .:lc,.    'cll:.  ..
         ...      .;lll,
                   .,,,.
"

usage() {
    cat <<EOF
amp-install ${SCRIPT_VERSION}

USAGE:
    install.sh [OPTIONS]

DESCRIPTION:
    Downloads and installs the Amp CLI tool for your platform.
    Amp is an agentic coding tool, in research preview from Sourcegraph.

OPTIONS:
    -h, --help          Show this help message and exit
    -V, --version       Show version information and exit
    --doctor            Show system diagnostics for troubleshooting
    -v, --verbose       Enable verbose output
    -q, --quiet         Disable progress output (quiet mode)
    --dry-run           Show what would be done without executing
    --no-confirm        Skip interactive prompts and use defaults

ENVIRONMENT VARIABLES:
    AMP_BINARY_ROOT     Override the binary download URL root
                        (default: https://packages.ampcode.com/binaries)
    AMP_OVERRIDE_URL    Override the complete binary download URL
    AMP_DRY_RUN         Enable dry-run mode (same as --dry-run)
    AMP_NO_CONFIRM      Skip confirmation prompts (same as --no-confirm)
    HTTP_PROXY          HTTP proxy server URL
    HTTPS_PROXY         HTTPS proxy server URL
    NO_PROXY            Comma-separated list of hosts to bypass proxy

EXAMPLES:
    # Standard installation
    curl -fsSL https://packages.ampcode.com/install.sh | sh

    # Dry run to see what would happen
    ./install.sh --dry-run

    # Quiet installation with no prompts
    ./install.sh --quiet --no-confirm

    # Verbose installation to see detailed output
    ./install.sh --verbose

    # Run system diagnostics for troubleshooting
    ./install.sh --doctor

For more information, visit: https://ampcode.com/manual
EOF
}

version() {
    echo "amp-install ${SCRIPT_VERSION}"
    echo "Platform: $(uname -s) $(uname -m)"
    echo "Shell: $0"
}

doctor() {
    echo "amp-install ${SCRIPT_VERSION} - System Diagnostics"
    echo "=================================================="
    echo ""

    # Basic system information
    echo "System Information:"
    echo "  OS: $(uname -s)"
    echo "  Architecture: $(uname -m)"
    echo "  Kernel: $(uname -r)"
    if command -v sw_vers >/dev/null 2>&1; then
        echo "  macOS Version: $(sw_vers -productVersion)"
    fi
    echo "  Shell: $0"
    echo "  User: $(whoami)"
    echo "  Working Directory: $(pwd)"
    echo ""

    # Detected architecture
    echo "Architecture Detection:"
    get_architecture
    echo "  Detected: $RETVAL"
    echo ""

    # OS Detection
    echo "Operating System Detection:"
    if is_macos; then
        echo "  macOS: ✓"
    else
        echo "  macOS: ✗"
    fi

    if is_windows; then
        echo "  Windows: ✓"
    else
        echo "  Windows: ✗"
    fi

    if is_wsl; then
        echo "  WSL: ✓"
    else
        echo "  WSL: ✗"
    fi

    if is_archlinux; then
        echo "  Arch Linux: ✓"
    else
        echo "  Arch Linux: ✗"
    fi

    if is_nixos; then
        echo "  NixOS: ✓"
    else
        echo "  NixOS: ✗"
    fi

    if is_debian; then
        echo "  Debian/Ubuntu: ✓"
    else
        echo "  Debian/Ubuntu: ✗"
    fi

    if is_ubuntu; then
        echo "  Ubuntu: ✓"
    else
        echo "  Ubuntu: ✗"
    fi
    echo ""

    # Package Managers
    echo "Package Managers:"
    if has_homebrew; then
        echo "  Homebrew: ✓ ($(brew --version 2>/dev/null | head -1))"
    else
        echo "  Homebrew: ✗"
    fi

    if has_nix; then
        echo "  Nix: ✓ ($(nix --version 2>/dev/null || nix-env --version 2>/dev/null | head -1))"
    else
        echo "  Nix: ✗"
    fi

    if has_npm; then
        echo "  npm: ✓ ($(npm --version 2>/dev/null))"
    else
        echo "  npm: ✗"
    fi

    if has_yarn; then
        echo "  yarn: ✓ ($(yarn --version 2>/dev/null))"
    else
        echo "  yarn: ✗"
    fi

    if has_pnpm; then
        echo "  pnpm: ✓ ($(pnpm --version 2>/dev/null))"
    else
        echo "  pnpm: ✗"
    fi

    if has_choco; then
        echo "  Chocolatey: ✓ ($(choco --version 2>/dev/null | head -1))"
    else
        echo "  Chocolatey: ✗"
    fi
    echo ""

    # Required commands
    echo "Required Commands:"
    local _commands="curl wget mktemp chmod mkdir rm rmdir uname"
    for cmd in $_commands; do
        if check_cmd "$cmd"; then
            echo "  $cmd: ✓ ($(command -v "$cmd"))"
        else
            echo "  $cmd: ✗ (required)"
        fi
    done
    echo ""

    # Environment Variables
    echo "Environment Variables:"
    echo "  AMP_BINARY_ROOT: ${AMP_BINARY_ROOT:-<default>}"
    echo "  AMP_OVERRIDE_URL: ${AMP_OVERRIDE_URL:-<not set>}"
    echo "  AMP_DRY_RUN: ${AMP_DRY_RUN:-<not set>}"
    echo "  AMP_NO_CONFIRM: ${AMP_NO_CONFIRM:-<not set>}"
    echo "  HTTP_PROXY: ${HTTP_PROXY:-<not set>}"
    echo "  HTTPS_PROXY: ${HTTPS_PROXY:-<not set>}"
    echo "  NO_PROXY: ${NO_PROXY:-<not set>}"
    echo "  TERM: ${TERM:-<not set>}"
    echo "  PATH: $PATH"
    echo ""

    # Network connectivity test
    echo "Network Connectivity:"
    if command -v curl >/dev/null 2>&1; then
        if curl -s --connect-timeout 5 "$AMP_BINARY_ROOT/" >/dev/null 2>&1; then
            echo "  Binary root accessible: ✓ ($AMP_BINARY_ROOT)"
        else
            echo "  Binary root accessible: ✗ ($AMP_BINARY_ROOT)"
        fi
    else
        echo "  Cannot test connectivity: curl not available"
    fi
    echo ""

    # Download URL that would be used
    local _arch="$RETVAL"
    local _ext=""
    case "$_arch" in
    *windows*)
        _ext=".exe"
        ;;
    esac
    local _url="${AMP_OVERRIDE_URL-${AMP_BINARY_ROOT}/amp-${_arch}${_ext}}"
    echo "Download Information:"
    echo "  Target URL: $_url"
    echo "  Binary name: amp${_ext}"
    echo ""

    # Temporary directory test
    echo "System Tests:"
    local _test_dir
    if _test_dir="$(mktemp -d 2>/dev/null)"; then
        echo "  Temp directory creation: ✓ ($_test_dir)"
        rmdir "$_test_dir" 2>/dev/null
    else
        echo "  Temp directory creation: ✗"
    fi

    # File permissions test
    if [ -w "$(pwd)" ]; then
        echo "  Current directory writable: ✓"
    else
        echo "  Current directory writable: ✗"
    fi

    echo ""
    echo "Diagnostics complete. Share this output when reporting issues."
}

main() {
    # Parse arguments first to set QUIET/VERBOSE flags
    local need_tty=yes
    local dry_run=no
    for arg in "$@"; do
        case "$arg" in
        --help | -h)
            print_logo
            usage
            exit 0
            ;;
        --version | -V)
            print_logo
            version
            exit 0
            ;;
        --doctor)
            doctor
            exit 0
            ;;
        --verbose | -v)
            VERBOSE=1
            ;;
        --quiet | -q)
            QUIET=1
            ;;
        --no-confirm)
            need_tty=no
            ;;
        --dry-run)
            dry_run=yes
            ;;
        *)
            continue
            ;;
        esac
    done

    # Check environment variables
    if [ "${AMP_NO_CONFIRM-}" ]; then
        need_tty=no
    fi
    if [ "${AMP_DRY_RUN-}" ]; then
        dry_run=yes
    fi

    # Now print logo (respects QUIET flag)
    print_logo

    need_cmd uname
    need_cmd mktemp
    need_cmd chmod
    need_cmd mkdir
    need_cmd rm
    need_cmd rmdir
    need_cmd curl

    get_architecture || return 1
    local _arch="$RETVAL"
    assert_nz "$_arch" "arch"

    local _ext=""
    case "$_arch" in
    *windows*)
        _ext=".exe"
        ;;
    esac

    local _url="${AMP_OVERRIDE_URL-${AMP_BINARY_ROOT}/amp-${_arch}${_ext}}"

    local _dir
    if ! _dir="$(run_cmd mktemp -d)"; then
        # Because the previous command ran in a subshell, we must manually
        # propagate exit status.
        exit 1
    fi
    local _file="${_dir}/amp${_ext}"

    local _ansi_escapes_are_valid=false
    if [ -t 2 ]; then
        if [ "${TERM+set}" = 'set' ]; then
            case "$TERM" in
            xterm* | rxvt* | urxvt* | linux* | vt*)
                _ansi_escapes_are_valid=true
                ;;
            esac
        fi
    fi

    if [ "$QUIET" -eq 0 ]; then
        if $_ansi_escapes_are_valid; then
            printf "\33[1minfo:\33[0m downloading amp \33[4m%s\33[0m\n" "$_url" 1>&2
        else
            printf 'info: downloading amp (%s)\n' "$_url" 1>&2
        fi
    fi

    verbose "Platform detected: $_arch"
    verbose "Download URL: $_url"
    verbose "Target file: $_file"

    run_cmd mkdir -p "$_dir"
    run_cmd curl -L -o "$_file" "$_url"
    run_cmd chmod u+x "$_file"

    if [ "$dry_run" = "no" ] && [ ! -x "$_file" ]; then
        printf '%s\n' "Cannot execute $_file (likely because of mounting /tmp as noexec)." 1>&2
        printf '%s\n' "Please copy the file to a location where you can execute binaries and run ./amp${_ext}." 1>&2
        exit 1
    fi

    if [ "$dry_run" = "yes" ]; then
        run_cmd "$_file" "$@"
    elif [ "$need_tty" = "yes" ] && [ ! -t 0 ]; then
        # The installer is going to want to ask for confirmation by
        # reading stdin.  This script was piped into `sh` though and
        # doesn't have stdin to pass to its children. Instead we're going
        # to explicitly connect /dev/tty to the installer's stdin.
        if [ ! -t 1 ]; then
            err "Unable to run interactively. Run with --dry-run to see what would be executed, --no-confirm to accept defaults, --help for additional options"
        fi

        run_cmd "$_file" "$@" </dev/tty
    else
        run_cmd "$_file" "$@"
    fi

    local _retval=$?

    run_cmd rm "$_file"
    run_cmd rmdir "$_dir"

    return "$_retval"
}

get_architecture() {
    local _ostype _cputype _arch
    _ostype="$(uname -s)"
    _cputype="$(uname -m)"

    if [ "$_ostype" = Linux ]; then
        if [ "$(uname -o)" = Android ]; then
            _ostype=Android
        fi
    fi

    if [ "$_ostype" = Darwin ]; then
        # Darwin `uname -m` can lie due to Rosetta shenanigans. If you manage to
        # invoke a native shell binary and then a native uname binary, you can
        # get the real answer, but that's hard to ensure, so instead we use
        # `sysctl` (which doesn't lie) to check for the actual architecture.
        if [ "$_cputype" = i386 ]; then
            # Handling i386 compatibility mode in older macOS versions (<10.15)
            # running on x86_64-based Macs.
            # Starting from 10.15, macOS explicitly bans all i386 binaries from running.
            # See: <https://support.apple.com/en-us/HT208436>

            # Avoid `sysctl: unknown oid` stderr output and/or non-zero exit code.
            if sysctl hw.optional.x86_64 2>/dev/null || true | grep -q ': 1'; then
                _cputype=x86_64
            fi
        elif [ "$_cputype" = x86_64 ]; then
            # Handling x86-64 compatibility mode (a.k.a. Rosetta 2)
            # in newer macOS versions (>=11) running on arm64-based Macs.
            # Rosetta 2 is built exclusively for x86-64 and cannot run i386 binaries.

            # Avoid `sysctl: unknown oid` stderr output and/or non-zero exit code.
            if sysctl hw.optional.arm64 2>/dev/null || true | grep -q ': 1'; then
                _cputype=arm64
            fi
        fi
    fi

    case "$_ostype" in
    Linux)
        _ostype=linux
        ;;

    Darwin)
        _ostype=darwin
        ;;

    *)
        err "unrecognized OS type: $_ostype"
        ;;

    esac

    case "$_cputype" in
    aarch64 | arm64)
        _cputype=aarch64
        ;;

    x86_64 | x86-64 | x64 | amd64)
        _cputype=x86_64
        ;;

    *)
        err "unknown CPU type: $_cputype"
        ;;

    esac

    _arch="${_cputype}-${_ostype}"

    RETVAL="$_arch"
}

say() {
    if [ "$QUIET" -eq 0 ]; then
        printf 'amp-install: %s\n' "$1"
    fi
}

verbose() {
    if [ "$VERBOSE" -eq 1 ]; then
        printf 'amp-install (verbose): %s\n' "$1" >&2
    fi
}

err() {
    printf 'amp-install: %s\n' "$1" >&2
    exit 1
}

need_cmd() {
    if ! check_cmd "$1"; then
        err "need '$1' (command not found)"
    fi
}

check_cmd() {
    command -v "$1" >/dev/null 2>&1
}

assert_nz() {
    if [ -z "$1" ]; then err "assert_nz $2"; fi
}

# Run a command that should never fail. If the command fails execution
# will immediately terminate with an error showing the failing
# command.
ensure() {
    if ! "$@"; then err "command failed: $*"; fi
}

# Run a command, with dry-run support
run_cmd() {
    # Check for dry-run flag in arguments to main script
    for arg in $SCRIPT_ARGS; do
        if [ "$arg" = "--dry-run" ]; then
            printf 'would run: %s\n' "$*" 1>&2
            return 0
        fi
    done

    if [ "${AMP_DRY_RUN-}" ]; then
        printf 'would run: %s\n' "$*" 1>&2
        return 0
    else
        verbose "Running: $*"
        "$@"
    fi
}

print_logo() {
    if [ "$QUIET" -eq 1 ]; then
        return
    fi

    # Only use colors if terminal supports them
    if [ -t 1 ] && [ "${TERM+set}" = 'set' ]; then
        case "$TERM" in
        xterm* | rxvt* | urxvt* | linux* | vt*)
            RED='\033[0;31m'
            NC='\033[0m'
            printf "${RED}${LOGO}${NC}\n"
            ;;
        *)
            printf "${LOGO}\n"
            ;;
        esac
    else
        printf "${LOGO}\n"
    fi
    printf "Amp - An agentic coding tool, in research preview from Sourcegraph\n\n"
}

# Package manager detection functions
has_homebrew() {
    check_cmd brew
}

has_nix() {
    check_cmd nix-env || check_cmd nix
}

has_pnpm() {
    check_cmd pnpm
}

has_yarn() {
    check_cmd yarn
}

has_npm() {
    check_cmd npm
}

has_choco() {
    check_cmd choco
}

# Operating system detection functions
is_archlinux() {
    [ -f /etc/arch-release ] || [ -f /etc/archlinux-release ]
}

is_nixos() {
    [ -f /etc/NIXOS ] || [ -f /etc/nixos/configuration.nix ]
}

is_debian() {
    [ -f /etc/debian_version ] || [ -f /etc/lsb-release ] && grep -q "Ubuntu\|Debian" /etc/lsb-release 2>/dev/null
}

is_ubuntu() {
    [ -f /etc/lsb-release ] && grep -q "Ubuntu" /etc/lsb-release 2>/dev/null
}

is_windows() {
    case "$(uname -s)" in
    CYGWIN* | MINGW* | MSYS*)
        return 0
        ;;
    *)
        return 1
        ;;
    esac
}

is_wsl() {
    # Check for WSL indicators
    [ -f /proc/version ] && grep -q "Microsoft\|WSL" /proc/version 2>/dev/null
}

is_macos() {
    [ "$(uname -s)" = "Darwin" ]
}

main "$@" || exit 1
