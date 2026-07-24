# Publisher banner for the Autodesk Design and Make Marketplace.
# Spec: 1280 x 200 px, png/gif/jpg, max 2 MB.
#
# Usage: powershell -ExecutionPolicy Bypass -File scripts/build-banner.ps1
#
# Palette taken from the live HydroComplete stylesheets (hc-refactored
# civil3d.html / marketing.html), not invented:
#   --navy #0d1b2a   --green #27ae60   --blue #3498db
#   --muted #8a99ac  --line #e6eaf0
#
# Motif is an SCS-style unit hydrograph -- on-brand for stormwater, and it reads
# as a technical instrument rather than clip art.

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Out  = Join-Path $Root 'marketplace\publisher_banner_1280x200.png'

$W = 1280; $H = 200

$navy   = [System.Drawing.Color]::FromArgb(255, 13, 27, 42)
$navyLo = [System.Drawing.Color]::FromArgb(255,  7, 14, 24)
$green  = [System.Drawing.Color]::FromArgb(255, 39, 174,  96)
$blue   = [System.Drawing.Color]::FromArgb(255, 52, 152, 219)
$muted  = [System.Drawing.Color]::FromArgb(255, 138, 153, 172)
$white  = [System.Drawing.Color]::White

$bmp = New-Object System.Drawing.Bitmap($W, $H, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g   = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode     = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

# --- background: navy, subtly darker to the right ------------------------
$bgRect = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
$bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($bgRect, $navy, $navyLo, [System.Drawing.Drawing2D.LinearGradientMode]::Horizontal)
$g.FillRectangle($bgBrush, $bgRect)

# --- faint engineering grid ---------------------------------------------
$gridPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(26, 138, 153, 172), 1)
for ($x = 0; $x -lt $W; $x += 40) { $g.DrawLine($gridPen, $x, 0, $x, $H) }
for ($y = 0; $y -lt $H; $y += 40) { $g.DrawLine($gridPen, 0, $y, $W, $y) }

# --- hydrograph, right half ---------------------------------------------
# SCS-style gamma: q = (t/tp)^a * exp(a*(1 - t/tp))
function Hydrograph([double]$tp, [double]$a, [int]$x0, [int]$x1, [int]$baseY, [int]$amp) {
    $pts = @()
    for ($x = $x0; $x -le $x1; $x += 4) {
        $t = ($x - $x0) / [double]($x1 - $x0) * 5.0
        $q = if ($t -le 0) { 0 } else { [Math]::Pow($t / $tp, $a) * [Math]::Exp($a * (1 - $t / $tp)) }
        $pts += [System.Drawing.PointF]::new($x, $baseY - $q * $amp)
    }
    return ,$pts
}

$baseY = 168
$curve  = Hydrograph 1.15 3.2 700 1240 $baseY 105   # post-development: peaky
$curve2 = Hydrograph 1.90 2.2 700 1240 $baseY 62    # attenuated by detention

# filled area under the peaky curve
$fillPts = @($curve) + @([System.Drawing.PointF]::new(1240, $baseY), [System.Drawing.PointF]::new(700, $baseY))
$fill = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(38, 39, 174, 96))
$g.FillPolygon($fill, [System.Drawing.PointF[]]$fillPts)

$axisPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(90, 138, 153, 172), 1.5)
$g.DrawLine($axisPen, 690, $baseY, 1250, $baseY)

$penG = New-Object System.Drawing.Pen($green, 3.0)
$penG.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
$g.DrawLines($penG, [System.Drawing.PointF[]]$curve)

$penB = New-Object System.Drawing.Pen($blue, 2.0)
$penB.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash
$g.DrawLines($penB, [System.Drawing.PointF[]]$curve2)

# --- wordmark ------------------------------------------------------------
$fontMark = New-Object System.Drawing.Font('Segoe UI', 40, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
$fontTag  = New-Object System.Drawing.Font('Segoe UI', 17, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
$brWhite  = New-Object System.Drawing.SolidBrush($white)
$brMuted  = New-Object System.Drawing.SolidBrush($muted)
$brGreen  = New-Object System.Drawing.SolidBrush($green)

# green rule as a left anchor
$g.FillRectangle($brGreen, 60, 66, 4, 68)

$g.DrawString('HydroComplete', $fontMark, $brWhite, 82, 62)
$g.DrawString('Stormwater analysis with every formula shown', $fontTag, $brMuted, 85, 116)

$bmp.Save($Out, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()

$size = (Get-Item $Out).Length
Write-Host ("Wrote {0}" -f $Out)
Write-Host ("  {0} x {1} px, {2:N0} bytes" -f $W, $H, $size)
if ($size -gt 2MB) { throw "Banner is $([Math]::Round($size/1MB,2)) MB -- over the 2 MB limit." }
