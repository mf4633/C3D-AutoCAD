# Generate ribbon button icons for the Field Kit.
#
# Usage: powershell -ExecutionPolicy Bypass -File scripts/build-icons.ps1
#
# Writes c3dfk_<CMD>_16.png and _32.png into
# marketplace/icons/ -- these are BUILD INPUTS, not shipped resources. They get
# embedded INTO C3DFieldKit.cuix by build-cuix.ps1. AutoCAD cannot resolve CUI
# button images from a support path -- they must live inside the .cuix package.
#
# Every glyph is drawn on a 32-unit design grid and scaled, so 16 and 32 px are
# the same artwork rather than a resample. Colour encodes the ribbon panel the
# command lives on, so a whole panel reads as a set.

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$Root   = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$OutDir = Join-Path $Root 'marketplace\icons'
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$Colors = @{
    Parcel        = [System.Drawing.Color]::FromArgb(255, 232, 145, 20)
    Survey        = [System.Drawing.Color]::FromArgb(255,  30, 165, 155)
    Text          = [System.Drawing.Color]::FromArgb(255,  56, 128, 200)
    Elevation     = [System.Drawing.Color]::FromArgb(255,  92, 160,  40)
    Layers        = [System.Drawing.Color]::FromArgb(255, 138,  94, 200)
    Utilities     = [System.Drawing.Color]::FromArgb(255, 100, 112, 128)
    HydroComplete = [System.Drawing.Color]::FromArgb(255, 232, 145, 20)
}

# --- tiny drawing helpers, all in 32-grid units -------------------------
$script:g = $null; $script:s = 1.0; $script:pen = $null; $script:brush = $null
function Ln($x1,$y1,$x2,$y2) { $script:g.DrawLine($script:pen, $x1*$script:s, $y1*$script:s, $x2*$script:s, $y2*$script:s) }
function Rc($x,$y,$w,$h)     { $script:g.DrawRectangle($script:pen, $x*$script:s, $y*$script:s, $w*$script:s, $h*$script:s) }
function FRc($x,$y,$w,$h)    { $script:g.FillRectangle($script:brush, $x*$script:s, $y*$script:s, $w*$script:s, $h*$script:s) }
function El($x,$y,$w,$h)     { $script:g.DrawEllipse($script:pen, $x*$script:s, $y*$script:s, $w*$script:s, $h*$script:s) }
function FEl($x,$y,$w,$h)    { $script:g.FillEllipse($script:brush, $x*$script:s, $y*$script:s, $w*$script:s, $h*$script:s) }
function Pg($pts) { $a = $pts | ForEach-Object { [System.Drawing.PointF]::new($_[0]*$script:s, $_[1]*$script:s) }; $script:g.DrawPolygon($script:pen, [System.Drawing.PointF[]]$a) }
function FPg($pts){ $a = $pts | ForEach-Object { [System.Drawing.PointF]::new($_[0]*$script:s, $_[1]*$script:s) }; $script:g.FillPolygon($script:brush, [System.Drawing.PointF[]]$a) }
function Arcg($x,$y,$w,$h,$start,$sweep) { $script:g.DrawArc($script:pen, $x*$script:s, $y*$script:s, $w*$script:s, $h*$script:s, $start, $sweep) }

# An irregular quad reused wherever "parcel / lot" is the idea.
$LOT = @(@(5,9),@(26,6),@(28,24),@(7,27))

$Glyphs = [ordered]@{
    # --- Parcel ---------------------------------------------------------
    LABELACRES = @{ Group='Parcel'; Draw={ Pg $LOT; FEl 13 13 7 7 } }
    TOTALAREA  = @{ Group='Parcel'; Draw={ FPg $LOT } }
    TLEN       = @{ Group='Parcel'; Draw={ Ln 4 22 12 10; Ln 12 10 20 20; Ln 20 20 28 8; FEl 2 20 5 5; FEl 25 5 5 5 } }
    BD         = @{ Group='Parcel'; Draw={ Ln 4 26 26 8; FPg @(@(26,8),@(18,9),@(24,15)); Ln 4 20 4 28 } }
    BDTBL      = @{ Group='Parcel'; Draw={ Rc 4 6 24 20; Ln 4 13 28 13; Ln 4 20 28 20; Ln 14 6 14 26 } }

    # --- Survey ---------------------------------------------------------
    NE         = @{ Group='Survey'; Draw={ Ln 16 3 16 29; Ln 3 16 29 16; FEl 13 13 6 6 } }
    ZL         = @{ Group='Survey'; Draw={ Ln 16 5 16 23; FPg @(@(16,3),@(11,10),@(21,10)); FPg @(@(16,29),@(11,22),@(21,22)); Ln 4 26 28 26 } }
    CENTROID   = @{ Group='Survey'; Draw={ Pg @(@(16,4),@(29,26),@(3,26)); FEl 13 16 6 6 } }
    SLP        = @{ Group='Survey'; Draw={ Pg @(@(4,26),@(28,26),@(28,8)); Ln 20 26 20 17 } }

    # --- Text -----------------------------------------------------------
    MAKEUPPER  = @{ Group='Text'; Draw={ Pg @(@(6,26),@(14,7),@(22,26)); Ln 9 20 19 20; FPg @(@(27,6),@(23,12),@(31,12)) } }
    MAKELOWER  = @{ Group='Text'; Draw={ El 7 14 14 13; Ln 21 14 21 27; FPg @(@(27,27),@(23,21),@(31,21)) } }
    TITLECASE  = @{ Group='Text'; Draw={ Pg @(@(3,25),@(10,8),@(17,25)); Ln 6 20 14 20; El 19 15 10 10 } }
    CTH        = @{ Group='Text'; Draw={ Pg @(@(5,25),@(13,8),@(21,25)); Ln 8 20 18 20; Ln 27 6 27 26; FPg @(@(27,4),@(24,9),@(30,9)); FPg @(@(27,28),@(24,23),@(30,23)) } }
    TROT       = @{ Group='Text'; Draw={ Arcg 6 6 20 20 30 260; FPg @(@(26,10),@(19,10),@(24,16)) } }
    SCALETXT   = @{ Group='Text'; Draw={ Ln 7 25 25 7; FPg @(@(27,5),@(19,6),@(26,13)); FPg @(@(5,27),@(6,19),@(13,26)) } }
    T2M        = @{ Group='Text'; Draw={ FRc 4 7 10 5; FRc 4 20 10 5; FPg @(@(24,16),@(17,11),@(17,21)); FRc 26 8 3 16 } }

    # --- Elevation ------------------------------------------------------
    FLAT       = @{ Group='Elevation'; Draw={ Pg @(@(6,4),@(24,4),@(28,12),@(10,12)); Ln 6 4 6 14; Ln 24 4 24 14; FRc 4 24 24 4 } }
    CHZ        = @{ Group='Elevation'; Draw={ Ln 4 26 28 26; Ln 16 6 16 20; FPg @(@(16,3),@(11,10),@(21,10)); FPg @(@(16,22),@(11,16),@(21,16)) } }
    GETZ       = @{ Group='Elevation'; Draw={ Ln 4 26 28 26; Ln 16 4 16 17; FPg @(@(16,22),@(10,14),@(22,14)); FEl 13 24 6 6 } }

    # --- Layers ---------------------------------------------------------
    LI         = @{ Group='Layers'; Draw={ FRc 4 12 16 14; Rc 12 5 16 14 } }
    LUI        = @{ Group='Layers'; Draw={ Rc 3 16 16 12; Rc 8 10 16 12; Rc 13 4 16 12 } }
    LDEL       = @{ Group='Layers'; Draw={ Rc 4 6 18 18; Ln 24 20 31 27; Ln 31 20 24 27 } }
    BC         = @{ Group='Layers'; Draw={ Rc 4 5 12 12; Rc 4 19 12 12; FEl 21 8 6 6; FEl 21 22 6 6 } }

    # --- Utilities ------------------------------------------------------
    PLT        = @{ Group='Utilities'; Draw={ Rc 7 4 18 8; FRc 4 12 24 10; Rc 9 20 14 8 } }
    PA         = @{ Group='Utilities'; Draw={ Ln 5 8 27 8; Rc 8 8 16 20; Ln 14 13 14 24; Ln 20 13 20 24; FRc 12 4 8 4 } }
    ZO         = @{ Group='Utilities'; Draw={ El 5 5 17 17; Ln 21 21 29 29 } }

    # --- Publisher ------------------------------------------------------
    FIELDKIT   = @{ Group='HydroComplete'; Draw={ Pg $LOT; FEl 2 6 6 6; FEl 23 3 6 6; FEl 25 21 6 6; FEl 4 24 6 6 } }
}

function New-Icon([string]$cmd, [int]$size) {
    $spec  = $Glyphs[$cmd]
    $color = $Colors[$spec.Group]

    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $script:g = [System.Drawing.Graphics]::FromImage($bmp)
    $script:g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $script:g.Clear([System.Drawing.Color]::Transparent)
    $script:s = $size / 32.0

    # Stroke stays >=1.4px so the glyph survives at 16px.
    $w = [Math]::Max(1.4, 2.6 * $script:s)
    $script:pen = New-Object System.Drawing.Pen($color, [float]$w)
    $script:pen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $script:pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $script:pen.EndCap   = [System.Drawing.Drawing2D.LineCap]::Round
    $script:brush = New-Object System.Drawing.SolidBrush($color)

    & $spec.Draw

    $path = Join-Path $OutDir ("c3dfk_{0}_{1}.png" -f $cmd.ToLower(), $size)
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $script:pen.Dispose(); $script:brush.Dispose(); $script:g.Dispose(); $bmp.Dispose()
}

$n = 0
foreach ($cmd in $Glyphs.Keys) {
    New-Icon $cmd 16
    New-Icon $cmd 32
    $n++
}
Write-Host "Wrote $($n * 2) icons ($n commands x 16px + 32px) -> $OutDir"
Write-Host "Groups: $(($Colors.Keys | Sort-Object) -join ', ')"
if ($n -ne 27) { throw "Expected 27 glyphs, defined $n -- ribbon buttons would be missing icons." }
