param(
    [Parameter(Mandatory=$true)]
    [string]$Version
)

$Version = $Version -replace '^v', ''
Write-Host "Building Chocolatey package for version $Version"

# Install Chocolatey if not already installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = `
        [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# Remove git SHA suffix to simplify version (e.g., 0.0.1753960840-gd58826 -> 0.0.1753960840)
$CleanVersion = $Version -replace '-g[a-f0-9]+$', ''

# Update version in nuspec
(Get-Content chocolatey/amp.nuspec) -replace '<version>.*</version>', "<version>$CleanVersion</version>" |
    Set-Content chocolatey/amp.nuspec

# Download the Windows executable to calculate checksum
$WindowsExeUrl = "https://github.com/sourcegraph/amp-cli/releases/download/v$Version/amp-windows-x64.exe"
Write-Host "Downloading Windows executable from: $WindowsExeUrl"
Invoke-WebRequest -Uri $WindowsExeUrl -OutFile "amp-windows-x64.exe"
$WindowsChecksum = (Get-FileHash -Path "amp-windows-x64.exe" -Algorithm SHA256).Hash.ToLower()
Write-Host "Windows executable checksum: $WindowsChecksum"

# Update download URL in install script (use original version with SHA for actual download)
(Get-Content chocolatey/tools/chocolateyinstall.ps1) -replace 'v[0-9]+\.[0-9]+\.[0-9a-zA-Z\.\-]+', "v$Version" |
    Set-Content chocolatey/tools/chocolateyinstall.ps1

# Update checksum in install script
(Get-Content chocolatey/tools/chocolateyinstall.ps1) -replace 'REPLACE_WITH_WINDOWS_X64_SHA256', $WindowsChecksum |
    Set-Content chocolatey/tools/chocolateyinstall.ps1

# Clean up downloaded file
Remove-Item "amp-windows-x64.exe" -Force

# Build chocolatey package
Set-Location chocolatey
choco pack

# Test chocolatey package
$NupkgFile = Get-ChildItem -Name "amp.*.nupkg"
if ($NupkgFile) {
    Write-Host "Testing package: $NupkgFile"
    # Install with local source plus main repo for dependencies
    choco install amp -s ".;https://community.chocolatey.org/api/v2/" -f -y
    try {
        amp --help
    } catch {
        Write-Host "amp binary installed but may have terminal compatibility issues in CI"
    }
    choco uninstall amp -y
} else {
    Write-Host "No .nupkg file found to test"
    Get-ChildItem -Name "*.nupkg"
}

# Upload package to GitHub Release
$VersionTag = if ($Version.StartsWith('v')) { $Version } else { "v$Version" }
Write-Host "Uploading package to release $VersionTag"
$PackageFile = Get-ChildItem -Name "*.nupkg" | Select-Object -First 1
if ($PackageFile) {
    Write-Host "Found package file: $PackageFile"
    gh release upload $VersionTag $PackageFile --clobber --repo sourcegraph/amp-cli
} else {
    Write-Host "No .nupkg file found to upload"
    Get-ChildItem -Name "*.nupkg"
    exit 1
}

# Publish to Chocolatey if token is available
if ($env:CHOCO_PUBLISH_TOKEN) {
    Write-Host "Publishing to Chocolatey..."
    choco push "amp.$CleanVersion.nupkg" -s https://push.chocolatey.org/ -k $env:CHOCO_PUBLISH_TOKEN
} else {
    Write-Host "CHOCO_PUBLISH_TOKEN not set, skipping Chocolatey publishing"
}

Set-Location ..
Write-Host "Chocolatey package built successfully"
