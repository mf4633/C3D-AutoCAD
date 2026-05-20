# Changelog

All notable changes to this project will be documented here.
Versions follow [Semantic Versioning](https://semver.org/).

## [1.1.0] - 2026-05-20

### Added
- `LICENSE` (MIT).
- `CHANGELOG.md`.
- `_utils.lsp` — shared helpers (`c3d:txth`, `c3d:bbcenter`, `c3d:rad->dms`, `c3d:az->bearing`). Loaded first by `LSPLOAD` / `acaddoc.lsp`.
- `acaddoc.lsp` — optional auto-loader that loads every routine when any drawing opens.
- `PLT` — plot every layout in the current drawing to a single multi-page PDF.
- `SCALETXT` — scale TEXT/MTEXT/ATTDEF in place (insertion point unchanged).
- `BDTBL` — bearings-and-distances table from a closed polyline.

### Changed
- All 23 existing routines now carry a standardized header block (author / version / date / command / args / example).
- `BD`, `SLP`, `LABELACRES`, `CENTROID`, `NE`, `ZL` now use shared helpers from `_utils.lsp` (no more duplicated `bbcenter` / `txth` / `rad->dms` / `az->bearing`).
- README grouped by category (Labels / Measure / Text / Layers / Util) and now documents `acaddoc.lsp` install.

### Fixed
- `MAKEUPPER` filtered `MTEXT,DTEXT` (DTEXT is not a valid `ssget` filter) — now `MTEXT,TEXT,ATTDEF`, matches `MAKELOWER` / `TITLECASE`, and supports selection prompt instead of always-all.

## [1.0.0] - prior to 2026-05-20

Initial collection of 23 LISP routines: `BD`, `BC`, `CENTROID`, `CHZ`, `CTH`, `FLAT`, `GETZ`, `LABELACRES`, `LDEL`, `LI`, `LSPLOAD`, `LUI`, `MAKELOWER`, `MAKEUPPER`, `NE`, `PA`, `SLP`, `TITLECASE`, `TLEN`, `TOTALAREA`, `T2M`, `TROT`, `ZL`, `ZO`.
