# Autodesk App Store listing — copy/paste

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
  NE          label a point with its northing and easting
  ZL          label an object's elevation
  CENTROID    mark the centre of a closed shape
  SLP         label the slope between two points

Text
  MAKEUPPER / MAKELOWER / TITLECASE   case-fold text and mtext, leaving inline
                                      formatting codes intact
  CTH         change text height across a selection
  TROT        rotate text to a chosen angle
  SCALETXT    scale text about its own insertion point
  T2M         convert text to mtext

Elevation
  FLAT        flatten a selection to a single Z
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

## Screenshots (2–3, still to capture)

1. The **C3D Field Kit** ribbon tab, all seven panels visible
2. A parcel with `LABELACRES` output
3. A `BDTBL` bearings table inserted on a lot

Max 2000×2000 px, 72–96 DPI, under 20 MB, up to 10 accepted.
A demo video is **recommended, not required** — skip it for v1.
