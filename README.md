# C3D-AutoCAD

LISP routines for the listless. Drop into AutoCAD / Civil 3D and `APPLOAD` the
ones you want — or load the whole folder at once with `LSPLOAD` after loading
any single file.

## Loading

1. Download the repo as a zip (or `git clone`).
2. In AutoCAD: `APPLOAD` → pick any `.lsp` file → **Load**.
3. To auto-load every file in the folder, load `lspload.lsp` once and run
   `LSPLOAD`, then pick any `.lsp` in the folder.
4. To persist across sessions, add the folder to **Options → Files →
   Trusted Locations** and **Support File Search Path**, or drop the files
   into your `acaddoc.lsp` startup.

## Routines

| Command       | File                | What it does                                                                 |
|---------------|---------------------|------------------------------------------------------------------------------|
| `LABELACRES`  | `labelacres.lsp`    | Label closed polylines / hatches / circles / ellipses / regions with area in **acres to the tenth** (e.g. `2.3 AC`). MText at bounding-box center. |
| `TOTALAREA`   | `totalarea.lsp`     | Sum the area of all selected closed entities; reports sq ft and acres.       |
| `TLEN`        | `totallength.lsp`   | Total length of selected lines / polylines / arcs / circles (ft + mi).       |
| `BD`          | `bd.lsp`            | Label a LINE with surveyor bearing (`N 12°34'56" E`) and length, rotated.    |
| `SLP`         | `slope.lsp`         | Slope label between two picked 3D points: percent, ratio (H:V), dv/dh.       |
| `CENTROID`    | `centroid.lsp`      | Place a POINT at the bounding-box center of a picked closed entity.          |
| `NE`          | `nelabel.lsp`       | Repeating N/E coordinate label at picked points.                             |
| `ZL`          | `zlabel.lsp`        | Repeating Z elevation label at picked points (use with OSNAP to TIN/contours).|
| `GETZ`        | `getz.lsp`          | Report the Z elevation of a picked object.                                   |
| `CHZ`         | `chz.lsp`           | Change the Z elevation of selected objects to a value.                       |
| `FLAT`        | `flatten.lsp`       | Flatten selected objects to Z=0 in place (LINE, ARC, CIRCLE, TEXT, INSERT, LWPOLYLINE-elev). |
| `MAKEUPPER`   | `makeupper.lsp`     | Selected TEXT/MTEXT → UPPERCASE.                                             |
| `MAKELOWER`   | `makelower.lsp`     | Selected TEXT/MTEXT → lowercase.                                             |
| `TITLECASE`   | `titlecase.lsp`     | Selected TEXT/MTEXT → Title Case.                                            |
| `TROT`        | `trot.lsp`          | Rotate upside-down TEXT/MTEXT/ATTDEF by 180° so it reads right-side up.      |
| `CTH`         | `chtxth.lsp`        | Change text height of selected TEXT/MTEXT/ATTDEF.                            |
| `T2M`         | `txt2mtxt.lsp`      | Convert selected DTEXT/TEXT → MTEXT (preserves height, style, rotation).     |
| `BC`          | `blkcount.lsp`      | Count block inserts grouped by block name (selection or whole drawing).      |
| `LI`          | `layiso.lsp`        | Isolate the layer of a picked object (turn every other layer OFF).           |
| `LUI`         | `layuniso.lsp`      | Turn ON and THAW every layer (reverse of `LI`).                              |
| `LDEL`        | `laydel.lsp`        | Delete every object on the picked object's layer (with confirmation).        |
| `PA`          | `purgeall.lsp`      | AUDIT + three PURGE passes + registered-app purge.                           |
| `ZO`          | `zoomobj.lsp`       | Zoom to selected objects.                                                    |
| `LSPLOAD`     | `lspload.lsp`       | Pick any `.lsp` in a folder; load every `.lsp` in that folder.               |

## Notes

- All entity creation uses `entmake`, so routines work without the `command`
  echo cluttering the screen.
- Text routines use `TEXTSIZE` (falls back to `DIMTXT`, then `1.0`) for label
  height so labels match the current annotative environment.
- `FLAT` does not handle 3DPOLY / 3DFACE / MESH / SURFACE — explode those
  first.
- `LABELACRES`, `TOTALAREA`, and `CENTROID` use `vla-get-Area` and
  `vla-GetBoundingBox`, so they work with hatches and self-intersecting
  polylines, but the label is placed at the bbox center, not the true
  centroid; move it if you want it elsewhere.
- `BD` writes bearings using the AutoCAD `%%d` degree code so the label is
  portable to any font.

## Contributing

Drop a single `.lsp` per command, with a header comment block that names the
command and what it does. Append a row to the table above.
