param(
  [Parameter(Mandatory = $true)]
  [string[]]$Path
)

$ErrorActionPreference = 'Stop'
$certificateBase64 = $env:SYNCTV_WINDOWS_CERTIFICATE_BASE64
$certificatePassword = $env:SYNCTV_WINDOWS_CERTIFICATE_PASSWORD
$configured = @($certificateBase64, $certificatePassword) |
  Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

if ($configured.Count -eq 0) {
  if (-not [string]::IsNullOrWhiteSpace($env:GITHUB_OUTPUT)) {
    'mode=unsigned' | Out-File -FilePath $env:GITHUB_OUTPUT -Append -Encoding utf8
  }
  Write-Host 'Windows signing is not configured; keeping the artifacts unsigned.'
  exit 0
}
if ($configured.Count -ne 2) {
  throw 'Windows signing requires both certificate and password secrets.'
}

$certificatePath = Join-Path $env:RUNNER_TEMP 'synctv-windows-signing.pfx'
try {
  [System.IO.File]::WriteAllBytes(
    $certificatePath,
    [System.Convert]::FromBase64String($certificateBase64)
  )
}
catch {
  throw "SYNCTV_WINDOWS_CERTIFICATE_BASE64 is invalid: $($_.Exception.Message)"
}

$windowsKits = Join-Path ${env:ProgramFiles(x86)} 'Windows Kits\10\bin'
$toolArchitecture = if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') { 'arm64' } else { 'x64' }
$signTools = Get-ChildItem -Path $windowsKits -Filter 'signtool.exe' -File -Recurse
$signTool = $signTools |
  Where-Object { $_.Directory.Name -eq $toolArchitecture } |
  Sort-Object -Property @{ Expression = { [version]$_.Directory.Parent.Name }; Descending = $true } |
  Select-Object -First 1
if ($null -eq $signTool) {
  $signTool = $signTools | Select-Object -First 1
}
if ($null -eq $signTool) {
  throw "signtool.exe was not found under $windowsKits"
}

$timestampUrl = if ([string]::IsNullOrWhiteSpace($env:SYNCTV_WINDOWS_TIMESTAMP_URL)) {
  'http://timestamp.digicert.com'
}
else {
  $env:SYNCTV_WINDOWS_TIMESTAMP_URL
}

foreach ($artifactPath in $Path) {
  $artifact = Resolve-Path -Path $artifactPath -ErrorAction Stop
  & $signTool.FullName sign `
    /fd SHA256 `
    /f $certificatePath `
    /p $certificatePassword `
    /td SHA256 `
    /tr $timestampUrl `
    $artifact.Path
  if ($LASTEXITCODE -ne 0) {
    throw "Authenticode signing failed for $($artifact.Path)."
  }
  & $signTool.FullName verify /pa /all $artifact.Path
  if ($LASTEXITCODE -ne 0) {
    throw "Authenticode verification failed for $($artifact.Path)."
  }
}

if (-not [string]::IsNullOrWhiteSpace($env:GITHUB_OUTPUT)) {
  'mode=signed' | Out-File -FilePath $env:GITHUB_OUTPUT -Append -Encoding utf8
}
