param(
  [Parameter(Mandatory = $true)]
  [string]$Version,

  [Parameter(Mandatory = $true)]
  [string]$OutputDirectory
)

$ErrorActionPreference = 'Stop'
$bundle = Get-ChildItem -Path 'build/windows' -Directory -Recurse |
  Where-Object { $_.FullName -match '[\\/]runner[\\/]Release$' } |
  Select-Object -First 1

if ($null -eq $bundle) {
  throw 'Windows release bundle was not found.'
}

New-Item -ItemType Directory -Force -Path $OutputDirectory | Out-Null
$archive = Join-Path $OutputDirectory "SyncTV-$Version-windows-x64.zip"
Compress-Archive -Path (Join-Path $bundle.FullName '*') -DestinationPath $archive -Force
