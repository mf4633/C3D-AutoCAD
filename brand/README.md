# Survey & Parcel Field Kit — logo & brand assets

Generated 2026-07-24. Vector sources are `.svg`; the wordmark is **outlined** (no
live text), so the files render identically on any machine with no font installed.

## The mark

A deed traverse (white) with a survey point set inside it, on the drafting-grid
navy plate already used by the product cover and thumbnail. It says land-surveying
in plan view, which is what the kit's 26 commands do: acreage labels, bearing and
distance tables, N/E coordinate labels, elevation labels.

## Files

| File | Use |
| --- | --- |
| `fk_icon.svg` | Primary app icon — plate + mark + **C3D FIELD KIT**. Use at 128 px and up. |
| `fk_mark.svg` | Mark only, full detail (sight lines + ring). Use 64–512 px. |
| `fk_mark_flat.svg` | Mark only, simplified (solid point, no sight lines). Use at 48 px and below. |
| `fk_lockup_dark.svg` | Horizontal lockup, light type — for dark backgrounds, transparent. |
| `fk_lockup_light.svg` | Horizontal lockup, navy type — for white/light backgrounds. |
| `fk_lockup_on_navy.svg` | Same lockup with the navy field baked in. |
| `png/fk_icon_{1024,512,256,128}.png` | Raster app icon with the words. |
| `png/fk_mark_{512,256,128,64,48,32,16}.png` | Raster mark; ≤48 px auto-switches to the simplified art. |
| `png/fk_lockup_*.png` | Raster lockups at 240 px and 480 px tall. |
| `png/c3dfk.ico` | Multi-resolution favicon (16/32/48/64/128/256) for the product page. |

## Palette

| Token | Hex | Where |
| --- | --- | --- |
| Navy plate | `#0D1B2A` | Icon field, matches `product/cover_1280x720.png` |
| Signal green | `#4FB67A` | Survey point, rule under the wordmark |
| Paper white | `#F4F8FA` | Parcel boundary, "C3D" |
| Muted slate | `#B9CBD6` | "FIELD KIT" on dark |
| Deep slate | `#40586B` | "FIELD KIT" on light |

Grid lines are white at 8 % opacity, eight divisions, clipped to the plate.

## Rules

- Keep clear space of at least the plate's corner radius (22 % of the icon's width) on all sides.
- Never re-set the wordmark in a different typeface — use these files.
- On busy photography, use `fk_lockup_on_navy.svg`, not the transparent version.
- Below 48 px use the flat mark. Below 24 px drop the words entirely.

## Regenerating

Built by `make_logo.py` (kept with the session scratch files, copied here as
`make_logo.py` if you want to tweak geometry). The wordmark is outlined from
Bahnschrift, a Windows system font, instanced at wght 700 / wdth 100 for "C3D"
and wght 600 / wdth 87 for "FIELD KIT". No font file is redistributed.
