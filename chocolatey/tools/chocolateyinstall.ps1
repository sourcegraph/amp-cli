$ErrorActionPreference = 'Stop'

$packageName = 'amp'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64 = 'https://packages.ampcode.com/binaries/cli/v0.0.1755619544/amp-windows-x64.exe'
$checksum64 = 'f543fc5be31d19a1fd4a4fd0e9bea83114656b1f7c72192816afb6b30480697c'

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
