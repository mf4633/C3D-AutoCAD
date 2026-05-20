# Recording the demo GIF

The README references `docs/demo.gif`. Capture once and the placeholder fills in. **Total shot time: ~90 seconds.** Recording prep: ~10 minutes.

## Tools

- **ScreenToGif** (Windows, free) — <https://www.screentogif.com>. Records a window region directly to .gif, lets you trim and crop after. Use this; OBS exports MP4 which won't render inline on GitHub.
- Or use the Xbox Game Bar (`Win+G`) → record MP4 → convert with `ffmpeg -i in.mp4 -vf "fps=15,scale=900:-1" demo.gif` — slightly more work.

## Setup (do once)

1. Open a real subdivision DWG that has:
   - 2-3 closed parcel polylines
   - One straight property LINE for the bearing demo
   - One closed boundary polyline (4-6 segments) for the table demo
   - Examples on disk: BSL site plans, Trinity Athletic Complex parcels, or Asheville Hwy #2 property limits all qualify.
2. `APPLOAD` → load `_utils.lsp`, then `LSPLOAD`, run `LSPLOAD`, pick any other `.lsp` in the folder. All 26 routines loaded.
3. Set `OSMODE` to include Endpoint + Intersection so picks are clean on camera.
4. Zoom so the command-line area and one parcel are both visible.
5. Set a **text style** with reasonable height (~5' for a survey-scale plan) before recording so labels don't dominate the frame.

## Shot list (the 90 seconds)

| Sec | Command | Action | Why it sells |
|---|---|---|---|
| 0-5  | `LABELACRES` | Window-select 3 parcel polys | "2.3 AC" labels appear instantly at bbox centers |
| 5-15 | `BD`         | Pick the property line       | Surveyor bearing + length label rotates along the line |
| 15-30 | `BDTBL`     | Pick the closed boundary, pick blank space | TABLE entity drops in with 6 segments labeled L1-L6 |
| 30-40 | `SLP`       | Pick two contour intersections | "2.50% (40.00:1)" slope label |
| 40-50 | `MAKEUPPER` | Window-select all sheet text  | All caps in one beat |
| 50-60 | `PA`         | Run on the dwg                 | Watch the AUDIT + 3 PURGE passes blow through |
| 60-75 | `LI` then `LUI` | Pick a contour, then run LUI | Isolate-then-restore swap |
| 75-90 | `ZO`         | Pick a block off-screen        | Snap zoom to it |

Trim, crop to ~900px wide, target file size < 8 MB so GitHub renders it inline.

## Drop-in

Save as `C:\Users\michael.flynn\Desktop\AI\C3D-AutoCAD\docs\demo.gif`, then:

```
cd C:\Users\michael.flynn\Desktop\AI\C3D-AutoCAD
git add docs/demo.gif
git commit -m "docs: add demo gif for README"
git push
```

The README placeholder image link `docs/demo.gif` will resolve immediately.
