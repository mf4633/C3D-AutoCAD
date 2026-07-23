# Build C3DFieldKit.bundle for Autodesk ApplicationPlugins folder.
# Usage: powershell -ExecutionPolicy Bypass -File scripts/package-marketplace.ps1
#
# 2026-07-23: first load attempt in Civil 3D 2026 showed NO ribbon tab and no
# working commands -- the whole package was being skipped. Root causes found by
# diffing against the three bundles that DO load on this machine (Grading
# Optimization, ADSK Project Explorer, HydroComplete):
#   1. Platform must be "Civil3D", not "AutoCAD*". Civil 3D filters the entire
#      ApplicationPackage on this, so a mismatch loads nothing at all -- which
#      is why both the tab and the commands were missing.
#   2. AppType="LISP" must be declared; without it the loader does not treat
#      a .lsp ModuleName as LISP.
#   3. <Command Local=...> is the localized COMMAND NAME, not a display label.
#      "Label Acres" registered a command containing a space.
#   4. GroupName should have no spaces.
# Consequence of #1: this bundle now targets Civil 3D only. To also support
# plain AutoCAD/Map, add a second <RuntimeRequirements Platform="AutoCAD"> block
# inside <Components> with its own ComponentEntry set, the way HydroComplete's
# bundle stacks one block per release.
#
# Release-code map (verified 2026-07-23 against Autodesk's release-vs-year note):
#   R24.2 = 2023   R24.3 = 2024   R25.0 = 2025   R25.1 = 2026   R26.0 = 2027
# SeriesMin/Max declare R24.2-R25.1 = Civil 3D 2023-2026. That range is chosen
# from what is INSTALLED and therefore testable on this machine: Civil 3D 2021,
# 2022, 2023, 2026. Both endpoints (2023, 2026) can be exercised; 2024 and 2025
# are bracketed but not installed, which is defensible for pure AutoLISP with no
# version-specific API calls -- but it IS an assumption, so say so if asked.
# The blueprint's original "test on 2025/2026/2027" matrix was aspirational:
# neither 2025 nor 2027 exists here, so declaring that range would have meant
# claiming three versions while being able to test exactly one.
#
# ProductCode / UpgradeCode below are real v4 GUIDs (generated 2026-07-23,
# replacing hand-typed placeholders). UpgradeCode must NEVER change across
# versions -- it is how Autodesk recognizes v1.1 as an upgrade of v1.0 rather
# than a second product. ProductCode changes per released version.

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$TemplateBundle = Join-Path $Root "marketplace\C3DFieldKit.bundle"
$OutRoot = Join-Path $Root "dist\C3DFieldKit_v1"
$OutBundle = Join-Path $OutRoot "C3DFieldKit.bundle"
$Contents = Join-Path $OutBundle "Contents"

# Command name -> source file (excludes acaddoc.lsp, lspload.lsp)
$Commands = [ordered]@{
    LABELACRES = @{ File = "labelacres.lsp";  Label = "Label Acres" }
    TOTALAREA  = @{ File = "totalarea.lsp";   Label = "Total Area" }
    TLEN       = @{ File = "totallength.lsp"; Label = "Total Length" }
    BD         = @{ File = "bd.lsp";          Label = "Bearing Distance" }
    BDTBL      = @{ File = "bdtbl.lsp";       Label = "BD Table" }
    SLP        = @{ File = "slope.lsp";       Label = "Slope Label" }
    NE         = @{ File = "nelabel.lsp";     Label = "NE Label" }
    ZL         = @{ File = "zlabel.lsp";      Label = "Z Label" }
    CENTROID   = @{ File = "centroid.lsp";    Label = "Centroid" }
    GETZ       = @{ File = "getz.lsp";        Label = "Get Z" }
    CHZ        = @{ File = "chz.lsp";         Label = "Change Z" }
    FLAT       = @{ File = "flatten.lsp";     Label = "Flatten Z" }
    MAKEUPPER  = @{ File = "makeupper.lsp";   Label = "Uppercase Text" }
    MAKELOWER  = @{ File = "makelower.lsp";   Label = "Lowercase Text" }
    TITLECASE  = @{ File = "titlecase.lsp";   Label = "Title Case" }
    TROT       = @{ File = "trot.lsp";       Label = "Rotate Text" }
    CTH        = @{ File = "chtxth.lsp";     Label = "Change Text Height" }
    SCALETXT   = @{ File = "scaletxt.lsp";   Label = "Scale Text" }
    T2M        = @{ File = "txt2mtxt.lsp";   Label = "Text to MText" }
    BC         = @{ File = "blkcount.lsp";   Label = "Block Count" }
    LI         = @{ File = "layiso.lsp";     Label = "Layer Isolate" }
    LUI        = @{ File = "layuniso.lsp";   Label = "Layer Unisolate" }
    LDEL       = @{ File = "laydel.lsp";     Label = "Layer Delete" }
    PA         = @{ File = "purgeall.lsp";   Label = "Purge All" }
    PLT        = @{ File = "plot.lsp";        Label = "Plot All PDF" }
    ZO         = @{ File = "zoomobj.lsp";    Label = "Zoom Objects" }
}

function New-Directory([string]$Path) {
    New-Item -ItemType Directory -Force -Path $Path | Out-Null
}

# Clean stage
if (Test-Path $OutBundle) { Remove-Item $OutBundle -Recurse -Force }
New-Directory $OutBundle
New-Directory $Contents
New-Directory (Join-Path $OutBundle "Help")
New-Directory (Join-Path $OutBundle "Resources")

# Copy static bundle assets from template
Copy-Item (Join-Path $TemplateBundle "Contents\bootstrap.lsp") $Contents
Copy-Item (Join-Path $TemplateBundle "Help\quickstart.html") (Join-Path $OutBundle "Help")
if (Test-Path (Join-Path $TemplateBundle "Resources\icon.png")) {
    Copy-Item (Join-Path $TemplateBundle "Resources\*") (Join-Path $OutBundle "Resources")
}
if (Test-Path (Join-Path $TemplateBundle "C3DFieldKit.cuix")) {
    Copy-Item (Join-Path $TemplateBundle "C3DFieldKit.cuix") $OutBundle
}

# Copy LISP sources
foreach ($entry in $Commands.Values) {
    $src = Join-Path $Root $entry.File
    if (-not (Test-Path $src)) { throw "Missing source file: $src" }
    Copy-Item $src (Join-Path $Contents $entry.File)
}
$utils = Join-Path $Root "_utils.lsp"
if (-not (Test-Path $utils)) { throw "Missing _utils.lsp" }
Copy-Item $utils $Contents

# Generate PackageContents.xml
$entries = @()
$entries += @"
    <ComponentEntry AppName="Bootstrap"
      Version="1.0.0"
      AppType="LISP"
      ModuleName="./Contents/bootstrap.lsp"
      AppDescription="Load shared C3D Field Kit helpers"
      LoadOnAutoCADStartup="True"
      LoadOnCommandInvocation="False" />
"@

foreach ($cmd in $Commands.Keys) {
    $info = $Commands[$cmd]
    # Local must be the COMMAND NAME, not a friendly label -- Local is the
    # localized command alias AutoCAD registers, so putting "Label Acres" there
    # registered a command with a space in it. Every working bundle on this
    # machine sets Local = Global.
    $entries += @"

    <ComponentEntry AppName="$cmd"
      Version="1.0.0"
      AppType="LISP"
      ModuleName="./Contents/$($info.File)"
      AppDescription="$($info.Label)"
      LoadOnAutoCADStartup="False"
      LoadOnCommandInvocation="True">
      <Commands GroupName="C3DFieldKit">
        <Command Global="$cmd" Local="$cmd" />
      </Commands>
    </ComponentEntry>
"@
}

$cuixEntry = ""
if (Test-Path (Join-Path $OutBundle "C3DFieldKit.cuix")) {
    $cuixEntry = @"

    <ComponentEntry AppName="C3DFieldKitUI"
      Version="1.0.0"
      ModuleName="./C3DFieldKit.cuix"
      AppDescription="C3D Field Kit ribbon panel"
      LoadOnAutoCADStartup="True"
      LoadOnCommandInvocation="False" />
"@
}

$xml = @"
<?xml version="1.0" encoding="utf-8"?>
<ApplicationPackage SchemaVersion="1.0"
  Name="C3D Field Kit"
  Description="26 production LISP macros for Civil 3D: parcel labels, bearings tables, survey labels, text tools, layers, plot-all-PDF. By the team behind HydroComplete (hydrocomplete.com/civil3d)."
  AppVersion="1.0.0"
  ProductCode="{717A5504-F411-4AF2-B1BD-245343975734}"
  UpgradeCode="{B7F2EEBD-775E-48E0-9F93-69C87DD17AA5}"
  Author="Michael Flynn, PE"
  HelpFile="./Help/quickstart.html"
  OnlineDocumentation="https://hydrocomplete.com/civil3d"
  Icon="./Resources/icon.png">
  <CompanyDetails Name="Michael Flynn, PE" Url="https://hydrocomplete.com" Email="support@hydrocomplete.com" />
  <Components Description="C3D Field Kit commands">
    <RuntimeRequirements OS="Win64" Platform="Civil3D" SeriesMin="R24.2" SeriesMax="R25.1" />
$($entries -join "")
$cuixEntry
  </Components>
</ApplicationPackage>
"@

# UTF-8 without BOM — autoloader parsers can choke on a BOM prefix.
$xmlPath = Join-Path $OutBundle "PackageContents.xml"
[System.IO.File]::WriteAllText($xmlPath, $xml, (New-Object System.Text.UTF8Encoding $false))

$lspCount = (Get-ChildItem $Contents -Filter "*.lsp").Count
Write-Host "Built bundle -> $OutBundle"
Write-Host "  LISP files in Contents: $lspCount"
Write-Host "  Commands in PackageContents.xml: $($Commands.Count)"
Write-Host ""
Write-Host "Local test: copy bundle to"
Write-Host "  $env:ProgramData\Autodesk\ApplicationPlugins\C3DFieldKit.bundle"
Write-Host "Then restart Civil 3D."
Write-Host ""
Write-Host "Next: build C3DFieldKit.cuix (see marketplace/CUI_BUILD_NOTES.md), add icons, compile installer."