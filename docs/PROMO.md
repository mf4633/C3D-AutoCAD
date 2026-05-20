# Post drafts for v1.1.0

Three drop-in drafts. Each calibrated to its audience — *don't reuse the same copy across channels*; the communities overlap and notice. Post the demo GIF first (see `RECORD-DEMO.md`); without it, conversion drops by roughly 5x.

Link: <https://github.com/mf4633/C3D-AutoCAD>
Release: <https://github.com/mf4633/C3D-AutoCAD/releases/tag/v1.1.0>

---

## 1. Reddit — r/AutoCAD (also crosspost to r/civil3d, r/Surveying)

**Title:**
`[OC] 26 AutoLISP utilities for AutoCAD / Civil 3D — bearings, area labels, B&D tables, slope labels — free, MIT`

**Body:**
```
Been collecting LISP routines for my own civil/survey work and finally cleaned them up into one repo. All free, MIT licensed, no DLLs / .NET / Dynamo — pure AutoLISP, works in vanilla AutoCAD too.

Highlights I use most often:

- LABELACRES — window-select parcels, get "2.3 AC" labels at the bbox center of each
- BD — pick a line, get a surveyor bearing label ("N 12°34'56" E") with length, rotated along the line
- BDTBL — pick a closed boundary, get an actual TABLE entity with L1/L2/L3... bearings & distances
- SLP — pick two 3D points, get "2.50% (40.00:1)" slope label between them
- PLT — plot every layout in the drawing to a single PDF next to the DWG
- MAKEUPPER / MAKELOWER / TITLECASE / TROT / SCALETXT — text cleanup
- LI / LUI / LDEL — layer isolate / restore / nuke
- PA — AUDIT + 3x PURGE pass for stubborn drawings

Install once: drop the folder in AutoCAD's Support File Search Path. Bundled `acaddoc.lsp` auto-loads every routine on every drawing open.

Repo (with full list): https://github.com/mf4633/C3D-AutoCAD

PRs welcome — header block convention is documented in any existing routine.
```

**Notes:**
- Reddit auto-flags posts with too many links; one repo link is fine.
- `[OC]` tag matters on r/CAD — they enforce attribution.
- Post Sunday 9-11 AM ET (US engineers checking phones with coffee).
- If asked about commercial use: MIT, no restrictions.

---

## 2. Autodesk Civil 3D forum

URL: <https://forums.autodesk.com/t5/civil-3d-forum/bd-p/120>
Category: pick "AutoCAD Civil 3D Customization" if it exists; otherwise general.

**Title:**
`Sharing — 26 free AutoLISP utilities for Civil 3D (MIT)`

**Body:**
```
Sharing a collection I've cleaned up and put on GitHub in case anyone finds it useful. All AutoLISP — no .NET, no Dynamo, no DLLs. MIT licensed, fork freely.

https://github.com/mf4633/C3D-AutoCAD

A few that have saved me the most time on actual job-runner work:

- LABELACRES — label closed polylines / hatches / regions with area in acres to 0.1 (e.g. "2.3 AC"). MText at the bounding-box center.
- BD — label a LINE with surveyor bearing and length, rotated and flipped right-side-up.
- BDTBL — generate an actual AutoCAD TABLE entity of bearings + distances for every segment of a closed polyline.
- SLP — slope label between two picked 3D points (percent, ratio, dv/dh) for grading and contour work.
- PLT — plot every paper-space layout to a single PDF next to the DWG.
- PA — AUDIT + three PURGE passes + registered-app purge.

Install path: drop the folder in Options → Files → Trusted Locations and Support File Search Path. The bundled acaddoc.lsp loads all 26 routines on every drawing open. Or one-off with APPLOAD.

Headers follow Lee Mac's convention so anyone tweaking should feel at home. Shared helpers (text height fallback, bearing/azimuth conversions, bbox center) are in _utils.lsp with the c3d: prefix to avoid clashing with your own routines.

Happy for feedback or PRs.
```

**Notes:**
- The Autodesk forum hates self-promo-flavored posts; "sharing" framing reads better than "I built".
- Don't cross-link to Reddit in this one — different communities, looks spammy.
- Engaged-user signal: respond within 24h to any reply, even one-liners.

---

## 3. LinkedIn

**Body (post text, no link preview customization needed — paste the GitHub URL last so LinkedIn renders the OG card):**
```
Cleaned up and open-sourced a collection of AutoLISP utilities I've been using for civil and survey work in AutoCAD and Civil 3D.

26 commands, MIT licensed:

→ Label closed polygons with area in acres in one click
→ Bearings + distances table from any closed polyline (true AutoCAD TABLE entity, not text)
→ Surveyor bearing labels on lines, rotated and flipped right-side-up
→ Slope labels between picked 3D points
→ Plot every layout to a single PDF next to the DWG
→ Plus 20+ more — text cleanup, layer isolate, audit-and-purge

Drop the folder in AutoCAD's Support File Search Path and the included auto-loader picks up all 26 routines on every drawing open.

If you spend any time on subdivisions, drainage exhibits, or sealed surveys in AutoCAD, you'll probably recognize half of these. PRs welcome.

https://github.com/mf4633/C3D-AutoCAD
```

**Notes:**
- LinkedIn's algorithm rewards posts that get comments in the first hour. Tag 1-2 colleagues you know would use it (Kim Kennedy, Daniel Bookhart, anyone in the McGill survey/drainage group), or any non-McGill civil-engineering contact.
- A demo GIF in the post itself outperforms a link by ~3x on LinkedIn — upload `demo.gif` as a native attachment.
- LinkedIn truncates after ~210 characters before "...see more"; first two lines should hook.
- Recommended post time: Tuesday-Thursday 7-9 AM ET.

---

## Order of operations (recommended)

1. Record the demo GIF (see `RECORD-DEMO.md`). Without it, all three posts under-convert.
2. Commit + push the GIF.
3. Post LinkedIn first — your warmest audience, lowest stakes, calibrates the copy.
4. 24 hours later, post on r/AutoCAD with the same GIF.
5. 48 hours later (after r/CAD reactions are in), post on the Autodesk forum.
6. Don't reuse identical wording across channels — Reddit users will spot the Autodesk forum copy and downvote as cross-promo.
