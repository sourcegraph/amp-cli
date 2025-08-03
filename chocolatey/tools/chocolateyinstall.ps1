$ErrorActionPreference = 'Stop'

$packageName = 'amp'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64 = 'https://packages.ampcode.com/binaries/cli/v0.0.1754223932/amp-windows-x64.exe'
$checksum64 = 'f872b980e153a7aa113ca3ef52f35ab405eac003a2bd454f61cecf9b24259ffe'

$packageArgs = @{
  packageName   = $packageName
  fileFullPath  = Join-Path $toolsDir 'amp.exe'
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= 'sha256'
}

Get-ChocolateyWebFile @packageArgs

# Create shim for amp.exe
$exePath = Join-Path $toolsDir 'amp.exe'
if (Test-Path $exePath) {
    Install-BinFile -Name 'amp' -Path $exePath
}
