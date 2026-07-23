param(
  [Parameter(Mandatory = $true)]
  [string]$Version,

  [Parameter(Mandatory = $true)]
  [ValidateSet('x64', 'arm64')]
  [string]$Architecture,

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
$archive = Join-Path $OutputDirectory "SyncTV-$Version-windows-$Architecture.zip"
Compress-Archive -Path (Join-Path $bundle.FullName '*') -DestinationPath $archive -Force

$symbolsDirectory = "build/symbols/windows-$Architecture"
if (-not (Test-Path -Path $symbolsDirectory -PathType Container)) {
  throw "Windows $Architecture symbols were not found: $symbolsDirectory"
}
$symbolsArchive = Join-Path $OutputDirectory "SyncTV-$Version-windows-$Architecture-symbols.zip"
Compress-Archive -Path (Join-Path $symbolsDirectory '*') -DestinationPath $symbolsArchive -Force
