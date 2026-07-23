param(
  [Parameter(Mandatory = $true)]
  [ValidateSet('x64', 'arm64')]
  [string]$Architecture
)

$ErrorActionPreference = 'Stop'
$expectedMachine = if ($Architecture -eq 'arm64') { 0xAA64 } else { 0x8664 }
$bundle = Get-ChildItem -Path build/windows -Directory -Recurse |
  Where-Object { $_.FullName -match '[\\/]runner[\\/]Release$' } |
  Select-Object -First 1
if ($null -eq $bundle) {
  throw 'Windows release bundle was not found under build/windows'
}

$checked = 0
Get-ChildItem -Path $bundle.FullName -File -Recurse |
  Where-Object { $_.Extension -in '.exe', '.dll' } |
  ForEach-Object {
    $stream = [System.IO.File]::OpenRead($_.FullName)
    try {
      $reader = [System.IO.BinaryReader]::new($stream)
      if ($reader.ReadUInt16() -ne 0x5A4D) {
        throw "Invalid PE header: $($_.FullName)"
      }
      $stream.Position = 0x3C
      $peOffset = $reader.ReadUInt32()
      $stream.Position = $peOffset
      if ($reader.ReadUInt32() -ne 0x00004550) {
        throw "Invalid PE signature: $($_.FullName)"
      }
      $machine = $reader.ReadUInt16()
      if ($machine -ne $expectedMachine) {
        throw ('Windows binary architecture mismatch: {0} has machine 0x{1:X4}, expected {2}' -f $_.FullName, $machine, $Architecture)
      }
      $checked += 1
    }
    finally {
      $stream.Dispose()
    }
  }

if ($checked -eq 0) {
  throw "No Windows PE binaries were found in $($bundle.FullName)"
}
Write-Host "Verified $checked Windows $Architecture binaries"
