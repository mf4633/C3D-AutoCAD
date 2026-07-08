# Changelog

All notable changes to this project will be documented here.
Versions follow [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Fixed
- `BC` counted dynamic and anonymous block inserts under their internal
  `*U###` names, scattering one logical block across many aliases. It now reads
  `EffectiveName` (falling back to DXF 2) so instances group under the real
  block name.

## [1.1.1] - 2026-07-08

### Added
- `c3d:mtext-case` in `_utils.lsp` — case-folds only the visible text of an
  MTEXT string, leaving inline format codes (`\P`, `\C1;`, `\fArial|…;`, `\H2x;`,
  grouping braces, stacked fractions) untouched.

### Fixed
- `MAKEUPPER` / `MAKELOWER` / `TITLECASE` corrupted MTEXT inline formatting by
  case-folding the format codes along with the text. They now route MTEXT
  through `c3d:mtext-case`; plain TEXT/ATTDEF keep the simple fold (so a literal
  backslash in a path is not mistaken for a code).
- `PLT` no longer overwrote the same PDF once per layout (leaving only the last
  layout, and prompting on overwrite). It now writes a DSD and runs `-PUBLISH`
  headlessly to collate every layout into one multi-page PDF, and reports a
  clear error if publishing fails.
- `TLEN` undercounted: `ELLIPSE` and `SPLINE` expose none of the probed VLA
  length properties and silently contributed 0. Length is now measured with
  `vlax-curve-getDistAtParam`, which is correct for every curve type.
- `LDEL` reported "Deleted N object(s)" even when the layer was locked and
  `ERASE` removed nothing. It now detects a locked layer and warns instead.

### Changed
- `BDTBL` no longer aborts via `(exit)` (which prints `; error: quit / exit
  abort`) on cancel / wrong pick — it bails cleanly with a message.
- README notes document the `TLEN`, `PLT`, text-case, and `LDEL` behavior above.

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
