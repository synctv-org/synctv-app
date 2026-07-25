param(
  [Parameter(Mandatory = $true)]
  [string]$Version,

  [Parameter(Mandatory = $true)]
  [ValidateSet('x64', 'arm64')]
  [string]$Architecture,

  [Parameter(Mandatory = $true)]
  [string]$OutputDirectory,

  [Parameter(Mandatory = $true)]
  [ValidatePattern('^https://')]
  [string]$RepositoryUrl
)

$ErrorActionPreference = 'Stop'
$bundle = Get-ChildItem -Path 'build/windows' -Directory -Recurse |
  Where-Object { $_.FullName -match '[\\/]runner[\\/]Release$' } |
  Select-Object -First 1

if ($null -eq $bundle) {
  throw 'Windows release bundle was not found.'
}

New-Item -ItemType Directory -Force -Path $OutputDirectory | Out-Null
$resolvedOutputDirectory = (Resolve-Path -Path $OutputDirectory).Path
$archive = Join-Path $OutputDirectory "SyncTV-$Version-windows-$Architecture.zip"
Compress-Archive -Path (Join-Path $bundle.FullName '*') -DestinationPath $archive -Force

$innoCompiler = Join-Path ${env:ProgramFiles(x86)} 'Inno Setup 6\ISCC.exe'
if (-not (Test-Path -Path $innoCompiler -PathType Leaf)) {
  throw "Inno Setup compiler was not found: $innoCompiler"
}
$installerScript = Join-Path $PSScriptRoot 'windows_installer.iss'
if (-not (Test-Path -Path $installerScript -PathType Leaf)) {
  throw "Windows installer definition was not found: $installerScript"
}
$installerName = "SyncTV-$Version-windows-$Architecture-setup"
& $innoCompiler `
  "/DAppVersion=$Version" `
  "/DSourceDirectory=$($bundle.FullName)" `
  "/DOutputDirectory=$resolvedOutputDirectory" `
  "/DOutputBaseFilename=$installerName" `
  "/DAppUrl=$RepositoryUrl" `
  "/DAppArchitecture=$Architecture" `
  $installerScript
if ($LASTEXITCODE -ne 0) {
  throw "Inno Setup failed with exit code $LASTEXITCODE."
}
$installer = Join-Path $resolvedOutputDirectory "$installerName.exe"
if (-not (Test-Path -Path $installer -PathType Leaf)) {
  throw "Windows installer was not generated: $installer"
}

$symbolsDirectory = "build/symbols/windows-$Architecture"
if (-not (Test-Path -Path $symbolsDirectory -PathType Container)) {
  throw "Windows $Architecture symbols were not found: $symbolsDirectory"
}
$symbolsArchive = Join-Path $OutputDirectory "SyncTV-$Version-windows-$Architecture-symbols.zip"
Compress-Archive -Path (Join-Path $symbolsDirectory '*') -DestinationPath $symbolsArchive -Force
