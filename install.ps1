# Amp CLI Windows Installer
# Usage: iwr -useb https://raw.githubusercontent.com/sourcegraph/amp-packages/main/install.ps1 | iex

param(
    [string]$Version = "1.0.0"
)

# Set error action
$ErrorActionPreference = "Stop"

# Colors for output
function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Check if command exists
function Test-Command {
    param([string]$Command)

    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

# Detect Windows architecture
function Get-Architecture {
    $arch = $env:PROCESSOR_ARCHITECTURE
    $wow64arch = $env:PROCESSOR_ARCHITEW6432

    if ($wow64arch -eq "AMD64" -or $arch -eq "AMD64") {
        return "amd64"
    }
    elseif ($wow64arch -eq "ARM64" -or $arch -eq "ARM64") {
        return "arm64"
    }
    else {
        throw "Unsupported architecture: $arch"
    }
}



# Install using Chocolatey
function Install-WithChocolatey {
    Write-Info "Installing via Chocolatey..."

    if (-not (Test-Command "choco")) {
        Write-Error "Chocolatey is not installed."
        return $false
    }

    try {
        choco install amp -y
        return $true
    }
    catch {
        Write-Error "Failed to install via Chocolatey: $($_.Exception.Message)"
        return $false
    }
}

# Install using Scoop
function Install-WithScoop {
    Write-Info "Installing via Scoop..."

    if (-not (Test-Command "scoop")) {
        Write-Error "Scoop is not installed."
        return $false
    }

    try {
        # Add bucket if not already added
        try {
            scoop bucket add sourcegraph https://github.com/sourcegraph/amp-packages
        }
        catch {
            # Bucket might already exist, continue
        }

        scoop install amp
        return $true
    }
    catch {
        Write-Error "Failed to install via Scoop: $($_.Exception.Message)"
        return $false
    }
}

# Manual installation by downloading binary
function Install-Manual {
    param([string]$Arch)

    Write-Info "Installing manually via binary download..."

    $binaryUrl = "https://github.com/sourcegraph/amp-packages/releases/download/v$Version/amp-windows-$Arch.zip"
    $tempDir = [System.IO.Path]::GetTempPath()
    $zipFile = Join-Path $tempDir "amp-windows-$Arch.zip"
    $extractDir = Join-Path $tempDir "amp-extract"

    # Determine installation directory
    $installDir = "$env:LOCALAPPDATA\Programs\Amp"
    $binPath = Join-Path $installDir "amp.exe"

    try {
        Write-Info "Downloading $binaryUrl..."
        Invoke-WebRequest -Uri $binaryUrl -OutFile $zipFile -UseBasicParsing

        Write-Info "Extracting archive..."
        if (Test-Path $extractDir) {
            Remove-Item $extractDir -Recurse -Force
        }
        Expand-Archive -Path $zipFile -DestinationPath $extractDir -Force

        Write-Info "Installing to $installDir..."
        if (-not (Test-Path $installDir)) {
            New-Item -ItemType Directory -Path $installDir -Force | Out-Null
        }

        # Find amp.exe in extracted files
        $ampExe = Get-ChildItem -Path $extractDir -Name "amp.exe" -Recurse | Select-Object -First 1
        if (-not $ampExe) {
            throw "amp.exe not found in downloaded archive"
        }

        $sourcePath = Join-Path $extractDir $ampExe.Name
        Copy-Item $sourcePath $binPath -Force

        # Add to PATH if not already there
        $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
        if ($userPath -notlike "*$installDir*") {
            Write-Host ""
            Write-Warning "The amp binary was installed to $installDir, which is not in your PATH."
            Write-Host "To make 'amp' available in your shell, we need to add this directory to your user PATH environment variable."
            Write-Host ""
            Write-Host "Current user PATH: $userPath" -ForegroundColor Gray
            Write-Host "Will add: $installDir" -ForegroundColor Yellow
            Write-Host ""
            $response = Read-Host "Do you want to add this to your user PATH environment variable? (y/N)"
            if ($response -eq "y" -or $response -eq "Y") {
                Write-Info "Adding $installDir to user PATH..."
                $newPath = "$userPath;$installDir"
                [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")

                # Update current session PATH
                $env:PATH = "$env:PATH;$installDir"
                Write-Success "PATH environment variable updated successfully!"
                Write-Warning "You may need to restart PowerShell for the changes to take effect."
            }
            else {
                Write-Warning "PATH not modified. You can manually add $installDir to your PATH environment variable."
                Write-Info "Or use the full path: $binPath"
            }
        }

        # Cleanup
        Remove-Item $zipFile -Force -ErrorAction SilentlyContinue
        Remove-Item $extractDir -Recurse -Force -ErrorAction SilentlyContinue

        return $true
    }
    catch {
        Write-Error "Failed to install manually: $($_.Exception.Message)"

        # Cleanup on failure
        Remove-Item $zipFile -Force -ErrorAction SilentlyContinue
        Remove-Item $extractDir -Recurse -Force -ErrorAction SilentlyContinue

        return $false
    }
}

# Check if running as administrator
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Main installation logic
function Main {
    Write-Info "Amp CLI Windows Installer"
    Write-Info "Version: $Version"
    Write-Host ""

    try {
        $arch = Get-Architecture
        Write-Info "Detected architecture: $arch"

        # Check if amp is already installed
        if (Test-Command "amp") {
            Write-Warning "Amp CLI is already installed. Use 'amp --version' to check the current version."
            $continue = Read-Host "Do you want to continue with installation? (y/N)"
            if ($continue -ne "y" -and $continue -ne "Y") {
                Write-Info "Installation cancelled."
                return
            }
        }

        $isAdmin = Test-Administrator
        if ($isAdmin) {
            Write-Info "Running as administrator"
        } else {
            Write-Info "Running as regular user"
        }

        # Try installation methods in order of preference
        $installed = $false

        # Try Chocolatey (Windows)
        if (Install-WithChocolatey) {
            Write-Success "Successfully installed Amp via Chocolatey!"
            $installed = $true
        }
        # Try Scoop
        elseif (Install-WithScoop) {
            Write-Success "Successfully installed Amp via Scoop!"
            $installed = $true
        }
        # Fall back to manual installation
        elseif (Install-Manual -Arch $arch) {
            Write-Success "Successfully installed Amp manually!"
            $installed = $true
        }
        else {
            Write-Error "All installation methods failed. Please install manually."
            Write-Info "Manual installation options:"
            Write-Info "1. Download from: https://github.com/sourcegraph/amp-packages/releases"
            Write-Info "2. Install Chocolatey: https://chocolatey.org/install"
            Write-Info "3. Install Scoop: https://scoop.sh/"
            exit 1
        }

        if ($installed) {
            Write-Host ""
            Write-Success "Amp CLI has been installed successfully!"
            Write-Info "Run 'amp --help' to get started."

            # Test if amp is available
            try {
                $version = & amp --version 2>$null
                if ($LASTEXITCODE -eq 0) {
                    Write-Success "Verification successful: $version"
                } else {
                    Write-Warning "amp command may not be immediately available. Try opening a new PowerShell window."
                }
            }
            catch {
                Write-Warning "amp command not found in current session. Please restart PowerShell or open a new window."
            }
        }
    }
    catch {
        Write-Error "Installation failed: $($_.Exception.Message)"
        exit 1
    }
}

# Check PowerShell version
if ($PSVersionTable.PSVersion.Major -lt 3) {
    Write-Error "PowerShell 3.0 or later is required. Current version: $($PSVersionTable.PSVersion)"
    exit 1
}

# Run main function
Main
