# Generate C3DFieldKit.cuix (partial customization file) WITHOUT opening the
# CUI editor, by driving AcCui.dll -- AutoCAD's customization API -- from a
# standalone process.
#
# Usage: powershell -ExecutionPolicy Bypass -File scripts/build-cuix.ps1
#
# Why the 2023 assembly: AcCui.dll loads fine out-of-process, and the 2023 build
# targets .NET Framework, which Windows PowerShell 5.1 can host. AutoCAD 2025+
# moved to .NET 8 and will not load here. A CUIX authored against the older
# schema is migrated forward by newer AutoCAD on load, so this is safe for the
# declared 2025-2027 range -- but VERIFY the panel renders in each release you
# claim, because that migration is the one step this script cannot test.
#
# Deviation from CUI_BUILD_NOTES.md: the notes call for a panel on the existing
# Plug-Ins tab. Merging into ACAD's own tab from a standalone generator means
# editing the base workspace, which is fragile. This builds a dedicated
# "C3D Field Kit" tab with WorkspaceBehavior=MergeOrAddTab instead -- it always
# renders. If Autodesk review insists on Plug-Ins, dragging the panel there in
# the CUI editor is a one-minute change.

$ErrorActionPreference = 'Stop'

$AcadDir  = 'C:\Program Files\Autodesk\AutoCAD 2023'
$Root     = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$OutFile  = Join-Path $Root 'marketplace\C3DFieldKit.bundle\C3DFieldKit.cuix'
$GroupName = 'C3DFIELDKIT'

Add-Type -Path (Join-Path $AcadDir 'AcCui.dll')

# Row assignment keeps related commands contiguous; 3 rows is what a ribbon
# panel displays without spilling into a slideout.
$Rows = @(
    @(  # Parcel + Survey + COGO
        @{ Cmd='LABELACRES'; Label='Label Acres' }
        @{ Cmd='TOTALAREA';  Label='Total Area' }
        @{ Cmd='TLEN';       Label='Total Length' }
        @{ Cmd='BD';         Label='Bearing Distance' }
        @{ Cmd='BDTBL';      Label='BD Table' }
        @{ Cmd='NE';         Label='NE Label' }
        @{ Cmd='ZL';         Label='Z Label' }
        @{ Cmd='CENTROID';   Label='Centroid' }
        @{ Cmd='SLP';        Label='Slope Label' }
    ),
    @(  # Text
        @{ Cmd='MAKEUPPER'; Label='Uppercase Text' }
        @{ Cmd='MAKELOWER'; Label='Lowercase Text' }
        @{ Cmd='TITLECASE'; Label='Title Case' }
        @{ Cmd='CTH';       Label='Change Text Height' }
        @{ Cmd='TROT';      Label='Rotate Text' }
        @{ Cmd='SCALETXT';  Label='Scale Text' }
        @{ Cmd='T2M';       Label='Text to MText' }
    ),
    @(  # Z + Layers + Utilities
        @{ Cmd='FLAT';   Label='Flatten Z' }
        @{ Cmd='CHZ';    Label='Change Z' }
        @{ Cmd='GETZ';   Label='Get Z' }
        @{ Cmd='LI';     Label='Layer Isolate' }
        @{ Cmd='LUI';    Label='Layer Unisolate' }
        @{ Cmd='LDEL';   Label='Layer Delete' }
        @{ Cmd='BC';     Label='Block Count' }
        @{ Cmd='PLT';    Label='Plot All PDF' }
        @{ Cmd='PA';     Label='Purge All' }
        @{ Cmd='ZO';     Label='Zoom Objects' }
    )
)

if (Test-Path $OutFile) { Remove-Item $OutFile -Force }

# A brand-new CustomizationSection has no MenuGroup until it is named and saved,
# so seed the file first, then reopen it to populate.
$cs = New-Object Autodesk.AutoCAD.Customization.CustomizationSection
$cs.MenuGroupName = $GroupName
$cs.MenuGroupDisplayName = 'C3D Field Kit'
$cs.SaveAs($OutFile) | Out-Null

$cs = New-Object Autodesk.AutoCAD.Customization.CustomizationSection($OutFile)
$mg = $cs.MenuGroup
if (-not $mg) { throw "MenuGroup still null after seed+reopen -- cannot continue." }

# --- Macros -------------------------------------------------------------
$macroGroup = New-Object Autodesk.AutoCAD.Customization.MacroGroup('C3D Field Kit', $mg)
$macros = @{}
foreach ($row in $Rows) {
    foreach ($c in $row) {
        # ^C^C cancels any in-progress command before invoking.
        $macros[$c.Cmd] = New-Object Autodesk.AutoCAD.Customization.MenuMacro(
            $macroGroup, $c.Label, "^C^C$($c.Cmd)", "C3DFK_$($c.Cmd)")
    }
}

# --- Panel --------------------------------------------------------------
$ribbonRoot = $mg.RibbonRoot
$panel = New-Object Autodesk.AutoCAD.Customization.RibbonPanelSource($ribbonRoot)
$panel.Name = 'C3D Field Kit'
$panel.Text = 'C3D Field Kit'
# Passing RibbonRoot to the ctor only sets the parent link -- it does NOT
# register the panel. Without this Add, the panel is silently dropped on save.
$ribbonRoot.RibbonPanelSources.Add($panel) | Out-Null

foreach ($rowDef in $Rows) {
    $row = New-Object Autodesk.AutoCAD.Customization.RibbonRow
    $panel.Items.Add($row) | Out-Null
    foreach ($c in $rowDef) {
        $btn = New-Object Autodesk.AutoCAD.Customization.RibbonCommandButton($row)
        # MenuMacroReference is read-only -- the button binds to its macro
        # purely through MacroID.
        $btn.MacroID     = $macros[$c.Cmd].ElementID
        # DisplayName is also read-only -- derived from the referenced macro's
        # name, which is why the macro is created with $c.Label as its name.
        $btn.Text        = $c.Label
        $btn.ButtonStyle = [Autodesk.AutoCAD.Customization.RibbonButtonStyle]::SmallWithText
        $btn.TooltipTitle = "$($c.Label)  ($($c.Cmd))"
        # Same trap as the panel: the ctor parents the button but does not
        # register it in the row.
        $row.Items.Add($btn) | Out-Null
    }
}

# --- Tab ----------------------------------------------------------------
$tab = New-Object Autodesk.AutoCAD.Customization.RibbonTabSource($ribbonRoot)
$tab.Name = 'C3D Field Kit'
$tab.Text = 'C3D Field Kit'
$tab.KeyTip = 'CFK'
$tab.DefaultDisplay = [Autodesk.AutoCAD.Customization.DefaultDisplay]::AddToWorkspace
$tab.WorkspaceBehavior = [Autodesk.AutoCAD.Customization.TabWorkspaceBehavior]::MergeOrAddTab
$ribbonRoot.RibbonTabSources.Add($tab) | Out-Null

$panelRef = New-Object Autodesk.AutoCAD.Customization.RibbonPanelSourceReference($tab)
$panelRef.PanelId = $panel.ElementID
$tab.Items.Add($panelRef) | Out-Null

$cs.Save() | Out-Null

# --- Verify by reopening ------------------------------------------------
$check = New-Object Autodesk.AutoCAD.Customization.CustomizationSection($OutFile)
$cmg   = $check.MenuGroup
$nMacro = ($cmg.MacroGroups | ForEach-Object { $_.MenuMacros.Count } | Measure-Object -Sum).Sum
$nPanel = $cmg.RibbonRoot.RibbonPanelSources.Count
$nTab   = $cmg.RibbonRoot.RibbonTabSources.Count
$nBtn   = ($cmg.RibbonRoot.RibbonPanelSources | ForEach-Object {
              $_.Items | ForEach-Object { $_.Items.Count } } | Measure-Object -Sum).Sum

Write-Host "Wrote $OutFile"
Write-Host ("  size:    {0:N0} bytes" -f (Get-Item $OutFile).Length)
Write-Host "  macros:  $nMacro (expect 26)"
$nRow = ($cmg.RibbonRoot.RibbonPanelSources | ForEach-Object { $_.Items.Count } | Measure-Object -Sum).Sum
Write-Host "  panels:  $nPanel (expect 1)"
Write-Host "  rows:    $nRow (expect 3)"
Write-Host "  tabs:    $nTab (expect 1)"
Write-Host "  buttons: $nBtn (expect 26)"
if ($nMacro -ne 26 -or $nBtn -ne 26 -or $nPanel -ne 1 -or $nTab -ne 1) {
    throw "Verification FAILED -- counts do not match."
}
Write-Host "Verification passed."
