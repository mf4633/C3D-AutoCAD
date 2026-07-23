# Build C3D_FieldKit_v1.zip for Gumroad upload.
# Usage: powershell -ExecutionPolicy Bypass -File scripts/package-release.ps1

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$OutDir = Join-Path $Root "dist"
$Stage = Join-Path $OutDir "C3D_FieldKit_v1"
$Zip = Join-Path $OutDir "C3D_FieldKit_v1.zip"
$Product = Join-Path $Root "product"

New-Item -ItemType Directory -Force -Path $Stage | Out-Null

# All LISP sources (buyer install uses acaddoc.lsp + Support Path)
Get-ChildItem -Path $Root -Filter "*.lsp" | Copy-Item -Destination $Stage
Copy-Item -Path (Join-Path $Root "LICENSE") -Destination (Join-Path $Stage "LICENSE.txt") -ErrorAction SilentlyContinue

# Buyer docs
Copy-Item -Path (Join-Path $Product "QUICK_START.md") -Destination $Stage
Copy-Item -Path (Join-Path $Product "CHEAT_SHEET.md") -Destination $Stage

if (Test-Path $Zip) { Remove-Item $Zip -Force }
Compress-Archive -Path (Join-Path $Stage "*") -DestinationPath $Zip -Force

$count = (Get-ChildItem $Stage).Count
Write-Host "Packaged $count files -> $Zip"
Write-Host "Upload this zip to Gumroad as the product file."