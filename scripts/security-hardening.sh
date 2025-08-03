#!/bin/bash
set -euo pipefail

# Security hardening utility for amp-cli scripts
# This script implements additional security measures

# Function to securely handle GPG operations
secure_gpg_sign() {
    local file_to_sign="$1"
    local output_file="$2"
    local gpg_key_id="$3"
    local passphrase="$4"

    # Validate all parameters are provided
    if [ -z "${file_to_sign:-}" ] || [ -z "${output_file:-}" ] || [ -z "${gpg_key_id:-}" ] || [ -z "${passphrase:-}" ]; then
        echo "ERROR: secure_gpg_sign requires 4 parameters: file_to_sign output_file gpg_key_id passphrase"
        return 1
    fi

    # Create secure temporary passphrase file
    local passphrase_file
    passphrase_file=$(mktemp -p "${RUNNER_TEMP:-${TMPDIR:-/tmp}}" gpg_passphrase.XXXXXX)
    chmod 600 "$passphrase_file"

    # Set up cleanup trap
    trap 'rm -f "$passphrase_file"' EXIT

    # Write passphrase securely (avoid echo which can expose to process list)
    printf '%s' "$passphrase" > "$passphrase_file"

    # Perform GPG signing
    gpg --batch --yes --no-tty --pinentry-mode loopback \
        --passphrase-file "$passphrase_file" \
        --default-key "$gpg_key_id" \
        --armor --detach-sign \
        --output "$output_file" \
        "$file_to_sign" 2>/dev/null

    # Explicit cleanup (trap will also handle this)
    rm -f "$passphrase_file"
}

# Function to mask sensitive environment variables
mask_secrets() {
    # Mask all known sensitive environment variables
    local sensitive_vars=(
        "ARCH_AUR_PUBLISH_PRIVATE_KEY"
        "AUR_SSH_PRIVATE_KEY"
        "CHOCO_PUBLISH_TOKEN"
        "DEB_GPG_PASSWORD"
        "DEB_GPG_PRIVATE_KEY"
        "DEB_GPG_PUBLIC_KEY"
        "GH_RELEASE_WORKFLOW_TOKEN"
        "GH_TOKEN"
        "GITHUB_TOKEN"
        "GPG_PASSPHRASE"
    )

    for var in "${sensitive_vars[@]}"; do
        if [ -n "${!var:-}" ]; then
            echo "::add-mask::${!var}"
        fi
    done
}

# Function to safely log environment (whitelist approach)
safe_env_log() {
    # Only log explicitly safe environment variables
    local safe_vars=(
        "PATH" "HOME" "USER" "SHELL" "TERM" "LANG" "TZ" "PWD" "OLDPWD"
        "GITHUB_WORKFLOW" "GITHUB_RUN_ID" "GITHUB_RUN_NUMBER"
        "GITHUB_ACTOR" "GITHUB_REPOSITORY" "GITHUB_REF" "GITHUB_SHA"
        "CI" "RUNNER_OS" "RUNNER_ARCH"
    )

    echo "Safe environment variables:"
    for var in "${safe_vars[@]}"; do
        if [ -n "${!var:-}" ]; then
            echo "$var=${!var}"
        fi
    done
}

# Function to create secure SSH configuration
setup_secure_ssh() {
    local ssh_key="$1"
    local host="$2"
    local user="$3"
    local known_host_key="$4"

    # Create SSH directory with secure permissions
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh

    # Create secure temporary key file
    local key_file
    key_file=$(mktemp -p "${RUNNER_TEMP:-${TMPDIR:-/tmp}}" ssh_key.XXXXXX)
    chmod 600 "$key_file"

    # Set up cleanup trap
    trap 'rm -f "$key_file"' EXIT

    # Write SSH key securely
    printf '%s\n' "$ssh_key" > "$key_file"

    # Also create expected file for legacy script compatibility
    if [[ "$host" == "aur.archlinux.org" ]]; then
        cp "$key_file" ~/.ssh/aur
        chmod 600 ~/.ssh/aur
        # Export key file path for script compatibility
        export AUR_SSH_KEY_FILE="$key_file"
    fi

    # Create SSH config with secure settings
    cat > ~/.ssh/config << EOF
Host $host
    StrictHostKeyChecking yes
    LogLevel ERROR
    IdentityFile $key_file
    User $user
    UserKnownHostsFile ~/.ssh/known_hosts
EOF
    chmod 600 ~/.ssh/config

    # Add verified host key
    echo "$known_host_key" >> ~/.ssh/known_hosts
    chmod 600 ~/.ssh/known_hosts
}

# Export functions for use in other scripts
export -f secure_gpg_sign
export -f mask_secrets
export -f safe_env_log
export -f setup_secure_ssh
