param(
  [Parameter(Mandatory = $true)]
  [string]$TargetRepo
)

$ErrorActionPreference = "Stop"
$sourceRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

Copy-Item "$sourceRoot\lib\*" "$TargetRepo\lib" -Recurse -Force
Copy-Item "$sourceRoot\assets\*" "$TargetRepo\assets" -Recurse -Force

Write-Host "Shared settings template files copied. Check pubspec.yaml assets manually."

