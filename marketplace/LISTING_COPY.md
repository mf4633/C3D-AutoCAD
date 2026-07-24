# Autodesk App Store listing — copy/paste

---

## Publisher profile (set once, applies to EVERY app)

| Field | Value |
|-------|-------|
| Company name | `HydroComplete` |
| Company URL | `https://hydrocomplete.com` |
| Support contact | `support@hydrocomplete.com` |
| PayPal | not required — free listing |

### Company description

```
HydroComplete makes stormwater and hydrology software for practising civil
engineers. Our tools run the standard methods — Rational, SCS/NRCS, Manning,
HEC-22 — and show the formula behind every number, so a result can be checked,
defended and sealed rather than taken on trust.

Built by a licensed professional engineer working in dam safety and water
resources, with Civil 3D tools that read pipe networks, catchments and surfaces
straight from the drawing instead of asking you to re-key them.

https://hydrocomplete.com
```

### Shorter variant, if the field is tight

```
Stormwater and hydrology software for civil engineers — browser-based analysis
and Civil 3D tools where every calculation shows its formula, so the work can be
checked, defended and sealed. Built by a licensed professional engineer.
https://hydrocomplete.com
```

> Deliberately avoids "our team" and any customer or install counts. The
> publisher profile is public and permanent; a claim that outruns reality is not
> worth the copy.

---


Fill the submission form at <https://apps.autodesk.com/en/MyUploads> with the
text below. Nothing here is aspirational: every claim matches what the bundle
actually does.

---

## App name

```
C3D Field Kit — 26 LISP Macros for Civil 3D
```

## Subtitle / short description

```
Parcel labels, bearings tables, coordinate and slope labels, text cleanup, layer chores and plot-all-to-PDF — 26 everyday drafting commands on one ribbon tab.
```

## Price

**Free.**

## Supported products / versions

Civil 3D **2023, 2024, 2025, 2026** (declared `R24.2`–`R25.1`, Win64).

> Tested on 2023 and 2026, the installed endpoints. 2024 and 2025 are bracketed
> by that range; the routines are plain AutoLISP with no version-specific API
> calls. If asked during review, say exactly that rather than implying all four
> were exercised.

## Tags

```
civil 3d, autocad, lisp, survey, parcel, cogo, bearings, annotation, drafting, productivity
```

---

## Long description (fits the 4000-character field)

```
C3D Field Kit puts 26 everyday drafting commands on a single ribbon tab, so the
small repetitive jobs stop costing you clicks.

It is plain AutoLISP. No .NET, no DLLs, no Dynamo, no background service. It
installs through the standard Autodesk autoloader — no APPLOAD, no Support File
Search Path edits, no Trusted Locations to configure.

WHAT YOU GET

Parcel
  LABELACRES  label closed polylines with their area in acres
  TOTALAREA   sum the area of any selection
  TLEN        total length across lines, arcs, polylines, splines and ellipses
  BD          label a segment with its bearing and distance
  BDTBL       insert a bearings-and-distances table for a lot

Survey
  NE          repeating northing/easting label at picked points
  ZL          repeating elevation label at picked points
  CENTROID    place a point at the bounding-box centre of a closed shape
  SLP         label slope between two picked points: percent, H:V and dv/dh

Text
  MAKEUPPER / MAKELOWER / TITLECASE   case-fold text and mtext, leaving inline
                                      formatting codes intact
  CTH         change text height across a selection
  TROT        flip upside-down text 180 degrees so it reads right-side up
  SCALETXT    scale text in place without moving its insertion point
  T2M         convert text to mtext, keeping height, style and rotation

Elevation
  FLAT        flatten a selection to Z=0 in place
  CHZ         change the Z of selected objects
  GETZ        read the Z of a picked object

Layers
  LI / LUI    isolate and unisolate layers
  LDEL        delete a layer and everything on it
  BC          count blocks by effective name, so dynamic blocks group correctly

Utilities
  PLT         plot every layout in the drawing to one PDF, next to the DWG
  PA          audit and purge, three passes
  ZO          zoom to selected objects

NOTES AND LIMITATIONS

Drawing units are assumed to be US survey feet. Area labels convert square feet
to acres at 43560 sf/ac. For metric drawings, change SQFT_PER_ACRE in the source
to 4046.856.

BD and BDTBL operate on polylines and lines. They do not read Civil 3D parcel
objects or alignment stationing.

FLAT does not handle 3DPOLY, 3DFACE, MESH or SURFACE — explode those first.

PLT requires the drawing to be saved, and writes the PDF beside the DWG.

LICENCE

MIT. Install and modify on any number of machines. Full source is public at
github.com/mf4633/C3D-AutoCAD.

WHO MADE IT

Built by the team behind HydroComplete — stormwater analysis driven straight
from your Civil 3D drawing, with full formula transparency.
https://hydrocomplete.com/civil3d
```

---

## Support

| Field | Value |
|-------|-------|
| Support email | `support@hydrocomplete.com` |
| Support / company URL | `https://hydrocomplete.com` |
| Online documentation | `https://hydrocomplete.com/civil3d` |
| Source | `https://github.com/mf4633/C3D-AutoCAD` |

## Licence / EULA

MIT — supply `LICENSE` from the repo root if the form wants a EULA file.

## Release notes — v1.0.0

```
First release. 26 drafting commands plus a FIELDKIT about command, on a
dedicated "C3D Field Kit" ribbon tab with seven panels. Autoloader install,
no configuration.
```

---

## Upload

Submit the **`.bundle` folder** (zipped): `dist/C3DFieldKit_v1_bundle.zip`.

Autodesk builds the MSI installer from an autoloader bundle — you do **not** need
to supply your own `.exe`/`.msi`. `marketplace/installer/C3DFieldKit.iss` is kept
only for local testing and the Gumroad channel.

## Step 1 form — the remaining fields

### Publisher Privacy Policy

```
https://hydrocomplete.com/privacy.html
```

### App File

Upload `dist/C3DFieldKit_v1_bundle.zip`. It already contains
`Help/quickstart.html`, which satisfies "include application and help file in a
zip archive".

### App Version

| Field | Value |
|-------|-------|
| Version Number | `1.0.0` |

Version Description:

```
First release. 26 drafting commands plus a FIELDKIT about command, on a dedicated "C3D Field Kit" ribbon tab with seven panels: Parcel, Survey, Text, Elevation, Layers, Utilities and publisher info. Installs through the Autodesk autoloader with no configuration.
```

### App Icon

`marketplace/C3DFieldKit.bundle/Resources/icon.png` (256×256 — the form scales
anything above 120×120).

### General Usage Instructions*

```
Every command is on the C3D Field Kit ribbon tab, and every command can also be typed at the command line if that is faster for you.

A typical parcel sheet: draw or import your lot polylines, run LABELACRES to tag each one with its area in acres, TOTALAREA to check the total against the plat, then BDTBL to drop a bearings-and-distances table for the lot. BD labels an individual segment where a full table is overkill.

A typical survey cleanup: NE to label northings and eastings, ZL for elevations, SLP for slope between two points, CENTROID to mark the middle of a closed shape.

Text cleanup before issue: MAKEUPPER, MAKELOWER or TITLECASE to normalise case across a selection, CTH to bring text heights into line, SCALETXT to resize without shifting insertion points, TROT to flip any upside-down labels right-side up, T2M to convert legacy text to mtext.

Before sending a drawing out: FLAT to drop everything to a single elevation, PA to audit and purge, then PLT to plot every layout to one PDF next to the DWG.

Layer work throughout: LI and LUI to isolate and unisolate, LDEL to remove a layer and its contents, BC to count blocks by effective name.

Run FIELDKIT at any time for the command summary and support details.
```

### Installation/Uninstallation*

```
Installation is handled by the Autodesk App Store installer. The plug-in is placed in the Autodesk ApplicationPlugins folder as C3DFieldKit.bundle, and loads automatically the next time Civil 3D starts. No APPLOAD, no Support File Search Path entry, and no Trusted Locations setting is required.

After installing, restart Civil 3D and look for the "C3D Field Kit" tab on the ribbon.

To uninstall, use the Autodesk App Manager from inside Civil 3D, or Windows Settings > Apps, and remove "C3D Field Kit". The ribbon tab and all commands disappear on the next restart. Nothing is left in your drawings: the commands only create ordinary AutoCAD text, mtext, tables and layers, which remain valid after the plug-in is removed.
```

### Support Information*

```
Email support@hydrocomplete.com. Please include your Civil 3D version, the command name, and what you did immediately before the problem.

Support is provided by the developer directly, Monday to Friday, US Eastern time. Most questions are answered within two business days.

This plug-in is MIT licensed and its full source is public at https://github.com/mf4633/C3D-AutoCAD, so you are also free to read the code, file an issue, or fix something yourself.
```

### Additional Information

```
Drawing units are assumed to be US survey feet. Area labels convert square feet to acres at 43560 sf/ac. For metric drawings, change SQFT_PER_ACRE in the source and reload.

The routines are plain AutoLISP. There is no .NET assembly, no ObjectARX module, no background process and no network access of any kind. Nothing is transmitted anywhere.

Licence: MIT. Install and modify on any number of machines. Source: https://github.com/mf4633/C3D-AutoCAD

Built by the team behind HydroComplete, stormwater analysis driven straight from your Civil 3D drawing: https://hydrocomplete.com/civil3d
```

### Known Issues

```
BD and BDTBL read polylines and lines, not Civil 3D parcel objects or alignment stationing, so a table built from a parcel's display geometry will not update if the parcel is later edited.

FLAT flattens to Z=0 specifically, not to a chosen elevation - use CHZ for that. It does not handle 3DPOLY, 3DFACE, MESH or SURFACE; explode those first.

PLT requires the drawing to have been saved, as it writes the PDF beside the DWG. Each layout uses its own page setup, so set page size, scale and plot area first.

CENTROID places its point at the bounding-box centre, not the true area centroid. For an irregular parcel those differ.

LDEL skips locked layers, since AutoCAD's ERASE ignores them silently. Unlock the layer first.

Area and length commands measure geometry as drawn; no drawing scale factor is applied.

Tested on Civil 3D 2023 and 2026. 2024 and 2025 fall inside the supported range and use the same AutoLISP interfaces, but were not separately exercised.
```

### Learn More Url

```
https://hydrocomplete.com/civil3d
```

---

## Screenshots (2–3, still to capture)

1. The **C3D Field Kit** ribbon tab, all seven panels visible
2. A parcel with `LABELACRES` output
3. A `BDTBL` bearings table inserted on a lot

Max 2000×2000 px, 72–96 DPI, under 20 MB, up to 10 accepted.
A demo video is **recommended, not required** — skip it for v1.
