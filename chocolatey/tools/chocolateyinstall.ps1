$ErrorActionPreference = 'Stop'

$packageName = 'amp'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64 = 'https://packages.ampcode.com/binaries/cli/v0.0.1755965097/amp-windows-x64.exe'
$checksum64 = 'a7991d3eee3ce1016a514f6fae5084c6af095a5c40a99d02a2d86b3916f7c13a'

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
