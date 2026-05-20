# C3D-AutoCAD

> LISP routines for the listless — 26 small commands for AutoCAD and Civil 3D, focused on civil-engineering daily-driver work: surveyor bearings, area / length totals, slope labels, text cleanup, layer chores, plot-all-to-PDF, bearings-and-distances tables.

All routines: pure AutoLISP / VLISP. No DLLs, no .NET, no Dynamo. Works in vanilla AutoCAD, AutoCAD Map, Civil 3D — anywhere `APPLOAD` works.

![placeholder — drop a demo GIF of LABELACRES or BDTBL here](docs/demo.gif)

## Install (one time)

**Auto-load on every drawing open (recommended):**

1. Clone or unzip this repo to a permanent folder, e.g. `C:\CAD\C3D-AutoCAD`.
2. AutoCAD → **Options → Files → Trusted Locations** → add the folder.
3. **Options → Files → Support File Search Path** → add the same folder.
4. Done. The bundled `acaddoc.lsp` auto-loads `_utils.lsp` + every routine each time a drawing opens.

**One-off load (no setup):**

- `APPLOAD` → pick any single `.lsp` → **Load**.
- Or load `lspload.lsp` once, run `LSPLOAD`, pick any `.lsp` in the folder, and every routine loads in dependency order.

## Routines

### Labels & measurement

| Cmd          | File              | What it does |
|--------------|-------------------|--------------|
| `LABELACRES` | `labelacres.lsp`  | Label closed polylines / hatches / circles / ellipses / regions with area in **acres to 0.1 ac** (e.g. `2.3 AC`). |
| `TOTALAREA`  | `totalarea.lsp`   | Sum area of selected closed entities; reports sq ft and acres. |
| `TLEN`       | `totallength.lsp` | Total length of selected lines / polylines / arcs / circles (ft + mi). |
| `BD`         | `bd.lsp`          | Label a LINE with surveyor bearing (`N 12°34'56" E`) and length, rotated along the line. |
| `BDTBL`      | `bdtbl.lsp`       | Insert a **Bearings-and-Distances TABLE** for every segment of a picked polyline. |
| `SLP`        | `slope.lsp`       | Slope label between two picked 3D points: percent, ratio (H:V), and dv/dh. |
| `NE`         | `nelabel.lsp`     | Repeating N/E coordinate label at picked points. |
| `ZL`         | `zlabel.lsp`      | Repeating Z elevation label at picked points (use with OSNAP to TIN / contours). |
| `CENTROID`   | `centroid.lsp`    | Place a POINT at the bounding-box center of a picked closed entity. |

### Elevation & geometry

| Cmd     | File          | What it does |
|---------|---------------|--------------|
| `GETZ`  | `getz.lsp`    | Report the Z elevation of a picked object. |
| `CHZ`   | `chz.lsp`     | Change the Z elevation of selected objects to a fixed value. |
| `FLAT`  | `flatten.lsp` | Flatten selected objects to Z=0 in place. |

### Text

| Cmd          | File             | What it does |
|--------------|------------------|--------------|
| `MAKEUPPER`  | `makeupper.lsp`  | Selected TEXT/MTEXT/ATTDEF → UPPERCASE. |
| `MAKELOWER`  | `makelower.lsp`  | Selected TEXT/MTEXT → lowercase. |
| `TITLECASE`  | `titlecase.lsp`  | Selected TEXT/MTEXT → Title Case. |
| `TROT`       | `trot.lsp`       | Rotate upside-down TEXT/MTEXT/ATTDEF by 180° so it reads right-side up. |
| `CTH`        | `chtxth.lsp`     | Change text height of selected TEXT/MTEXT/ATTDEF. |
| `SCALETXT`   | `scaletxt.lsp`   | **Scale text in place** by a factor without moving the insertion point. |
| `T2M`        | `txt2mtxt.lsp`   | Convert selected DTEXT/TEXT → MTEXT (preserves height, style, rotation). |

### Layers & blocks

| Cmd    | File             | What it does |
|--------|------------------|--------------|
| `BC`   | `blkcount.lsp`   | Count block inserts grouped by block name. |
| `LI`   | `layiso.lsp`     | Isolate the layer of a picked object (everything else OFF). |
| `LUI`  | `layuniso.lsp`   | Turn ON and THAW every layer (reverse of `LI`). |
| `LDEL` | `laydel.lsp`     | Delete every object on the picked object's layer (with confirmation). |

### File & view utilities

| Cmd        | File           | What it does |
|------------|----------------|--------------|
| `PA`       | `purgeall.lsp` | AUDIT + three `PURGE` passes + registered-app purge. |
| `PLT`      | `plot.lsp`     | **Plot every layout to a single PDF** next to the DWG, using "DWG To PDF.pc3". |
| `ZO`       | `zoomobj.lsp`  | Zoom to selected objects. |
| `LSPLOAD`  | `lspload.lsp`  | Pick any `.lsp` in a folder; load every `.lsp` in that folder (loads `_utils.lsp` first). |

### Library files (no command)

| File          | Purpose |
|---------------|---------|
| `_utils.lsp`  | Shared helpers: `c3d:txth`, `c3d:bbcenter`, `c3d:rad->dms`, `c3d:az->bearing`. Loaded first. |
| `acaddoc.lsp` | Auto-loader. Drop into the Support File Search Path and every routine loads on every drawing open. |

## Notes

- All entity creation uses `entmake`, so routines work without `command`-line echo cluttering the screen.
- Text routines use `c3d:txth` (TEXTSIZE → DIMTXT → 1.0) so labels match the current annotative environment.
- `FLAT` does not handle 3DPOLY / 3DFACE / MESH / SURFACE — explode those first.
- `LABELACRES`, `TOTALAREA`, and `CENTROID` use `vla-get-Area` and `vla-GetBoundingBox`, so they work with hatches and self-intersecting polylines; the label is placed at the bbox center, not the true centroid (move it if you want it elsewhere).
- `BD` and `BDTBL` write bearings using the AutoCAD `%%d` degree code so labels are portable to any font.
- `PLT` requires the drawing to be saved (writes the PDF next to the DWG).

## Contributing

Drop a single `.lsp` per command, with the standard header block (see any existing routine for the template) and append a row to the appropriate table above. Don't duplicate `c3d:*` helpers — add to `_utils.lsp` instead.

## License

MIT — see [LICENSE](LICENSE). Use, fork, modify, ship.

## Changelog

See [CHANGELOG.md](CHANGELOG.md).
