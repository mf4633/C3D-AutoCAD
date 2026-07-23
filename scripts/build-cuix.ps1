# Generate C3DFieldKit.cuix (partial customization file) WITHOUT opening the
# CUI editor, by driving AcCui.dll -- AutoCAD's customization API -- from a
# standalone process.
#
# Usage: powershell -ExecutionPolicy Bypass -File scripts/build-cuix.ps1
#
# Why the 2023 assembly: AcCui.dll loads fine out-of-process, and the 2023 build
# targets .NET Framework, which Windows PowerShell 5.1 can host. AutoCAD 2025+
# moved to .NET 8 and will not load here. A CUIX authored against the older
# schema is migrated forward by newer AutoCAD on load.
#
# LAYOUT (revised 2026-07-23 after first visual test): the first version put all
# 26 buttons into three rows on ONE panel -- 9-10 small buttons per row. Civil 3D
# rendered that as a single truncated button with an unusable overflow, because a
# ribbon row that wide cannot be drawn. Autodesk's own partial CUIX files put 1-3
# buttons in a row and use SEVERAL panels per tab. This now builds one panel per
# command group, each capped at 3 rows, which is the structure CUI_BUILD_NOTES.md
# specified in the first place.
#
# Also learned from diffing Autodesk's CollaborateTab.cuix:
#   - every panel ends with a RibbonPanelBreak
#   - the tab carries an Alias (ID_TAB*), which is how workspaces reference it
#
# Deviation from CUI_BUILD_NOTES.md: builds a dedicated "C3D Field Kit" tab
# (WorkspaceBehavior=MergeOrAddTab) rather than panels on the Plug-Ins tab,
# because merging into ACAD's base workspace from outside AutoCAD is fragile.

$ErrorActionPreference = 'Stop'

$AcadDir   = 'C:\Program Files\Autodesk\AutoCAD 2023'
$Root      = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$OutFile   = Join-Path $Root 'marketplace\C3DFieldKit.bundle\C3DFieldKit.cuix'
$GroupName = 'C3DFIELDKIT'
$MaxRows   = 3      # a ribbon panel draws at most 3 stacked rows

Add-Type -Path (Join-Path $AcadDir 'AcCui.dll')

# One panel per command group. Group sizes are small on purpose -- a panel with
# more than ~6 small buttons starts to crowd the tab.
$Panels = @(
    @{ Name = 'Parcel'; Cmds = @(
        @{ Cmd='LABELACRES'; Label='Label Acres' }
        @{ Cmd='TOTALAREA';  Label='Total Area' }
        @{ Cmd='TLEN';       Label='Total Length' }
        @{ Cmd='BD';         Label='Bearing Distance' }
        @{ Cmd='BDTBL';      Label='BD Table' }
    )},
    @{ Name = 'Survey'; Cmds = @(
        @{ Cmd='NE';       Label='NE Label' }
        @{ Cmd='ZL';       Label='Z Label' }
        @{ Cmd='CENTROID'; Label='Centroid' }
        @{ Cmd='SLP';      Label='Slope Label' }
    )},
    @{ Name = 'Text'; Cmds = @(
        @{ Cmd='MAKEUPPER'; Label='Uppercase' }
        @{ Cmd='MAKELOWER'; Label='Lowercase' }
        @{ Cmd='TITLECASE'; Label='Title Case' }
        @{ Cmd='CTH';       Label='Text Height' }
        @{ Cmd='TROT';      Label='Rotate Text' }
        @{ Cmd='SCALETXT';  Label='Scale Text' }
        @{ Cmd='T2M';       Label='Text to MText' }
    )},
    @{ Name = 'Elevation'; Cmds = @(
        @{ Cmd='FLAT'; Label='Flatten Z' }
        @{ Cmd='CHZ';  Label='Change Z' }
        @{ Cmd='GETZ'; Label='Get Z' }
    )},
    @{ Name = 'Layers'; Cmds = @(
        @{ Cmd='LI';   Label='Isolate' }
        @{ Cmd='LUI';  Label='Unisolate' }
        @{ Cmd='LDEL'; Label='Delete Layer' }
        @{ Cmd='BC';   Label='Block Count' }
    )},
    @{ Name = 'Utilities'; Cmds = @(
        @{ Cmd='PLT'; Label='Plot All PDF' }
        @{ Cmd='PA';  Label='Purge All' }
        @{ Cmd='ZO';  Label='Zoom Objects' }
    )}
)

# Split n items into at most $MaxRows balanced rows: base per row, with the
# remainder spread one-per-row across the leading rows.
function Split-IntoRows($items, $maxRows) {
    $n = @($items).Count
    $rows = [Math]::Min($n, $maxRows)
    $base = [Math]::Floor($n / $rows)
    $rem  = $n % $rows
    $out = @(); $i = 0
    for ($r = 0; $r -lt $rows; $r++) {
        $take = $base + $(if ($r -lt $rem) { 1 } else { 0 })
        $out += ,@($items[$i..($i + $take - 1)])
        $i += $take
    }
    return $out
}

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
foreach ($p in $Panels) {
    foreach ($c in $p.Cmds) {
        # ^C^C cancels any in-progress command before invoking.
        $macros[$c.Cmd] = New-Object Autodesk.AutoCAD.Customization.MenuMacro(
            $macroGroup, $c.Label, "^C^C$($c.Cmd)", "C3DFK_$($c.Cmd)")
    }
}

# --- Panels -------------------------------------------------------------
$ribbonRoot = $mg.RibbonRoot
$panelIds = @()

foreach ($p in $Panels) {
    $panel = New-Object Autodesk.AutoCAD.Customization.RibbonPanelSource($ribbonRoot)
    $panel.Name = "C3D Field Kit - $($p.Name)"
    $panel.Text = $p.Name
    # Passing RibbonRoot to the ctor only sets the parent link -- it does NOT
    # register the panel. Without this Add, the panel is silently dropped on save.
    $ribbonRoot.RibbonPanelSources.Add($panel) | Out-Null

    foreach ($rowCmds in (Split-IntoRows $p.Cmds $MaxRows)) {
        $row = New-Object Autodesk.AutoCAD.Customization.RibbonRow
        $panel.Items.Add($row) | Out-Null
        foreach ($c in $rowCmds) {
            $btn = New-Object Autodesk.AutoCAD.Customization.RibbonCommandButton($row)
            # MenuMacroReference and DisplayName are read-only -- a button binds
            # to its macro through MacroID alone.
            $btn.MacroID      = $macros[$c.Cmd].ElementID
            $btn.Text         = $c.Label
            $btn.ButtonStyle  = [Autodesk.AutoCAD.Customization.RibbonButtonStyle]::SmallWithText
            $btn.TooltipTitle = "$($c.Label)  ($($c.Cmd))"
            # Same trap as the panel: the ctor parents the button but does not
            # register it in the row.
            $row.Items.Add($btn) | Out-Null
        }
    }

    # Autodesk's own partial CUIX files close every panel with a break.
    $brk = New-Object Autodesk.AutoCAD.Customization.RibbonPanelBreak($panel)
    $panel.Items.Add($brk) | Out-Null

    $panelIds += $panel.ElementID
}

# --- Tab ----------------------------------------------------------------
$tab = New-Object Autodesk.AutoCAD.Customization.RibbonTabSource($ribbonRoot)
$tab.Name = 'C3D Field Kit'
$tab.Text = 'C3D Field Kit'
$tab.KeyTip = 'CFK'
$tab.DefaultDisplay = [Autodesk.AutoCAD.Customization.DefaultDisplay]::AddToWorkspace
$tab.WorkspaceBehavior = [Autodesk.AutoCAD.Customization.TabWorkspaceBehavior]::MergeOrAddTab
$tab.Aliases.Add('ID_TAB_C3DFIELDKIT') | Out-Null
$ribbonRoot.RibbonTabSources.Add($tab) | Out-Null

# NB: not $pid -- that is a read-only PowerShell automatic variable.
foreach ($panelId in $panelIds) {
    $panelRef = New-Object Autodesk.AutoCAD.Customization.RibbonPanelSourceReference($tab)
    $panelRef.PanelId = $panelId
    $tab.Items.Add($panelRef) | Out-Null
}

$cs.Save() | Out-Null

# --- Verify by reopening ------------------------------------------------
$check = New-Object Autodesk.AutoCAD.Customization.CustomizationSection($OutFile)
$cmg   = $check.MenuGroup
$rowType = [Autodesk.AutoCAD.Customization.RibbonRow]

$nMacro = ($cmg.MacroGroups | ForEach-Object { $_.MenuMacros.Count } | Measure-Object -Sum).Sum
$nPanel = $cmg.RibbonRoot.RibbonPanelSources.Count
$nTab   = $cmg.RibbonRoot.RibbonTabSources.Count
$nRef   = ($cmg.RibbonRoot.RibbonTabSources | ForEach-Object { $_.Items.Count } | Measure-Object -Sum).Sum
$rows   = $cmg.RibbonRoot.RibbonPanelSources | ForEach-Object { $_.Items | Where-Object { $rowType.IsInstanceOfType($_) } }
$nRow   = @($rows).Count
$nBtn   = ($rows | ForEach-Object { $_.Items.Count } | Measure-Object -Sum).Sum
$maxPerRow = ($rows | ForEach-Object { $_.Items.Count } | Measure-Object -Maximum).Maximum

$expPanel = $Panels.Count
Write-Host "Wrote $OutFile"
Write-Host ("  size:          {0:N0} bytes" -f (Get-Item $OutFile).Length)
Write-Host "  macros:        $nMacro (expect 26)"
Write-Host "  panels:        $nPanel (expect $expPanel)"
Write-Host "  panel refs:    $nRef (expect $expPanel)"
Write-Host "  rows:          $nRow"
Write-Host "  buttons:       $nBtn (expect 26)"
Write-Host "  max btns/row:  $maxPerRow (must be <= 3, the whole point of this rewrite)"
if ($nMacro -ne 26 -or $nBtn -ne 26 -or $nPanel -ne $expPanel -or $nTab -ne 1 -or $nRef -ne $expPanel) {
    throw "Verification FAILED -- counts do not match."
}
if ($maxPerRow -gt 3) { throw "Verification FAILED -- a row has $maxPerRow buttons; panel will truncate again." }
Write-Host "Verification passed."
