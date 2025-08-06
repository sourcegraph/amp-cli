$ErrorActionPreference = 'Stop'

$packageName = 'amp'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64 = 'https://packages.ampcode.com/binaries/cli/v0.0.1754462457/amp-windows-x64.exe'
$checksum64 = 'c95e2d7f61b426985f69a574a6b6e38f3ee44b5015f1c00d25a94aeeed131b36'

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
