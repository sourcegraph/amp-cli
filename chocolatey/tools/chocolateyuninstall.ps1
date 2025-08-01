$ErrorActionPreference = 'Stop'

$packageName = 'amp'

# Remove the shim
Uninstall-BinFile -Name 'amp'

Write-Host "Amp CLI has been uninstalled."
