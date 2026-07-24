# C3D Field Kit — ribbon / CUIX notes

Autodesk requires every Marketplace plug-in to present a **ribbon UI** via a
**partial CUIX**. This kit's CUIX is **generated from source**, not hand-built in
the CUI editor.

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build-icons.ps1   # button icons
powershell -ExecutionPolicy Bypass -File scripts/build-cuix.ps1    # the ribbon
```

`build-icons.ps1` draws all 27 glyphs at 16 and 32 px into `marketplace/icons/`,
colour-coded by panel. Those are **build inputs, not shipped resources** —
`build-cuix.ps1` embeds them into the `.cuix`. Run it first; the CUIX build
fails if any icon is missing.

`build-cuix.ps1` writes `marketplace/C3DFieldKit.bundle/C3DFieldKit.cuix`, then reopens it and
asserts the structure. `scripts/package-marketplace.ps1` copies it into the
shipping bundle and emits the matching `ComponentEntry` automatically.

Editing the ribbon means editing the `$Panels` table at the top of
`build-cuix.ps1` and re-running it. **Do not** hand-edit the CUIX in the CUI
editor — the next generator run overwrites it.

---

## How it works

`build-cuix.ps1` loads `AcCui.dll` — AutoCAD's own customization API — from a
standalone PowerShell process and builds the macros, panels, buttons and tab
programmatically.

**It must be the AutoCAD 2023 copy of `AcCui.dll`.** That build targets .NET
Framework, which Windows PowerShell 5.1 can host. AutoCAD 2025+ moved to .NET 8
and will not load in 5.1. A CUIX authored against the 2023 schema is migrated
forward by newer AutoCAD on load.

### API traps (all cost real debugging time)

| Trap | Consequence |
|------|-------------|
| `RibbonPanelSource`, `RibbonCommandButton`, `RibbonTabSource` take their parent in the constructor but **do not register themselves** in the parent's collection | Without an explicit `.Add()` the object is **silently dropped on save** — no error, no warning, it simply is not in the file |
| `MenuMacroReference` and `DisplayName` are **read-only** | A button binds to its macro through `MacroID` only; `DisplayName` is derived from the macro's name, which is why macros are created with the button label as their name |
| `CustomizationSection` has no `MenuGroup` until named **and saved** | The script seeds the file, then reopens it before populating |
| `$pid` is a read-only PowerShell automatic variable | Using it as a loop variable is a hard error |
| `Macro.SmallImage` / `LargeImage` **cannot be set out-of-process** — the setter and both image-carrying constructors throw `NullReferenceException`, because they resolve the bitmap through a cache that only exists inside a running AutoCAD | Icons are patched into the saved `.cuix` afterwards (it is an OPC zip: extract, edit `MenuGroup.cui`, rezip). See `Set-CuixIcons` in `build-cuix.ps1` |
| CUI button images **cannot be resolved from a support path** | They must be **embedded in the `.cuix`**. Leaving them in `Resources/` with `SupportPath` set renders every button as the cloud-with-question-mark placeholder. Contract, from Autodesk's `acetmain.cuix`: parts at the **zip root**, extension declared in `[Content_Types].xml`, `Name` includes the extension |
| Panels and tabs get a **fresh random `ElementID`** on every build unless you set one | AutoCAD merges a tab into the workspace **by ID**. New IDs orphan the previous merge and the ribbon **silently stops rendering** — on every rebuild locally, and for every customer on upgrade. Set stable IDs (`ID_C3DFK_PANEL_*`, `ID_TAB_C3DFIELDKIT`), as Autodesk does (`ID_PanelSharedViews`) |

---

## Layout rules

Learned the hard way: the first build put all 26 buttons on **one** panel at
9–10 small buttons per row. Civil 3D rendered that as a **single truncated
button with an unusable overflow** — a ribbon row that wide cannot be drawn.

Autodesk's own partial CUIX files put **1–3 buttons in a row** and use
**several panels per tab**. Follow that:

- **≤ 3 buttons per row**, **≤ 3 rows per panel**
- Split commands into small named panels rather than one large one
- Close every panel with a `RibbonPanelBreak`
- Give the tab an `<Alias>` (`ID_TAB_C3DFIELDKIT`) — that is how workspaces
  reference it

`build-cuix.ps1` **fails the build** if any row exceeds 3 buttons, so this
regression cannot ship again silently.

### Current layout — dedicated "C3D Field Kit" tab, 7 panels

| Panel | Buttons |
|-------|---------|
| **Parcel** | `LABELACRES` · `TOTALAREA` · `TLEN` · `BD` · `BDTBL` |
| **Survey** | `NE` · `ZL` · `CENTROID` · `SLP` |
| **Text** | `MAKEUPPER` · `MAKELOWER` · `TITLECASE` · `CTH` · `TROT` · `SCALETXT` · `T2M` |
| **Elevation** | `FLAT` · `CHZ` · `GETZ` |
| **Layers** | `LI` · `LUI` · `LDEL` · `BC` |
| **Utilities** | `PLT` · `PA` · `ZO` |
| **HydroComplete** | `FIELDKIT` (About — publisher attribution on the tab itself) |

27 commands total = 26 drafting macros + 1 About entry. The product name
"26 LISP Macros" counts macros, not commands — leave it alone.

**Why a dedicated tab instead of a panel on Plug-Ins:** merging into ACAD's base
workspace from a standalone generator means editing the base workspace, which is
fragile. `WorkspaceBehavior=MergeOrAddTab` always renders. If review insists on
Plug-Ins placement, drag the panels there in the CUI editor once and export.

---

## PackageContents.xml must agree

The CUIX renders nothing if the bundle itself is skipped. Four attributes matter
(see `scripts/package-marketplace.ps1`, and the 2026-07-23 diagnosis in its
header comment):

| Attribute | Required value | Why |
|-----------|----------------|-----|
| `Platform` | `Civil3D` — **not** `AutoCAD*` | Civil 3D filters the whole `ApplicationPackage` on this. A mismatch loads **nothing**: no tab *and* no commands |
| `AppType` | `LISP` on every `ComponentEntry` | Without it a `.lsp` `ModuleName` is not treated as LISP |
| `<Command Local=…>` | the command name, `Local` = `Global` | `Local` is the localized command alias, not a display label. A label with a space registers a command with a space in its name |
| `GroupName` | no spaces (`C3DFieldKit`) | Matches every working bundle on the machine |

Also: `RuntimeRequirements` goes **inside** `<Components>`; the attribute is
`OnlineDocumentation`, not `OnlineDocumentationLink`; there is no
`AutodeskProduct` attribute in any shipped Autodesk bundle.

Consequence of `Platform="Civil3D"`: the bundle does **not** load in plain
AutoCAD or Map 3D. Supporting those means a second `RuntimeRequirements` block
with its own `ComponentEntry` set — the way `HydroComplete.bundle` stacks one
block per release.

---

## Debugging a ribbon that does not appear

Diff against bundles that **do** load on this machine. A `.cuix` is a zip —
extract it and read `RibbonRoot.cui`.

| Reference | Path |
|-----------|------|
| Autodesk partial CUIX (small, ideal) | `C:\Program Files\Autodesk\AutoCAD 2022\C3D\CollaborateTab.cuix` |
| Autodesk Civil 3D plug-in | `C:\Program Files\Autodesk\ApplicationPlugins\ADSK-ProjectExplorer-2026.bundle` |
| Autodesk Civil 3D plug-in | `%ProgramData%\Autodesk\ApplicationPlugins\groundforce.bundle` |
| Our own .NET Civil 3D add-in | `%APPDATA%\Autodesk\ApplicationPlugins\HydroComplete.bundle` |

Order of diagnosis:

1. **Neither tab nor commands** → the whole package is being skipped. Check
   `Platform`, `SeriesMin`/`SeriesMax`, `AppType`, and that
   `PackageContents.xml` is UTF-8 **without BOM**.
2. **Commands work, no tab** → the CUIX `ComponentEntry` is missing, or the
   panel/tab was dropped on save (see the registration trap above).
3. **Tab appeared once, then vanished after a rebuild** → orphaned workspace
   merge from changed `ElementID`s. Confirm the CUIX still has stable IDs, then
   force a re-merge: `CUILOAD` → unload `C3DFIELDKIT` → OK → restart Civil 3D.
   A structurally perfect CUIX looks exactly like a broken one in this state, so
   check IDs before suspecting the file.
4. **Buttons show a cloud with a question mark** → that is AutoCAD's
   "image not found" placeholder. The images are not embedded in the `.cuix`,
   or `[Content_Types].xml` does not declare their extension. A support path
   will not fix it.
5. **Tab appears but the panel is truncated** → too many buttons per row.
6. **Still nothing** → check the `APPAUTOLOAD` system variable; it gates
   autoloading entirely.

---

## Local test

```powershell
Copy-Item dist\C3DFieldKit_v1\C3DFieldKit.bundle `
  "$env:ProgramData\Autodesk\ApplicationPlugins\C3DFieldKit.bundle" -Recurse -Force
```

Restart Civil 3D. `%ProgramData%` is deliberate — it is the same path the Inno
Setup installer targets, so the tested install matches the shipped one. No
elevation required.

**What the generator can and cannot prove.** It verifies the file round-trips
through Autodesk's API with the expected macro, panel, row and button counts. It
cannot verify that the panel *renders*, that macros *fire*, or that the
2023-authored schema migrates cleanly into 2026. Those need a running Civil 3D.

---

## Release codes

`R24.0`=2021 · `R24.1`=2022 · `R24.2`=2023 · `R24.3`=2024 · `R25.0`=2025 ·
`R25.1`=2026 · `R26.0`=2027

Declared range is `R24.2`–`R25.1` (2023–2026), chosen from what is installed and
therefore testable: **Civil 3D 2021, 2022, 2023, 2026**. Test the endpoints,
2023 and 2026. Do not widen the range to releases you cannot run.

---

## Common review failures

| Issue | Fix |
|-------|-----|
| No ribbon panel | Partial CUIX not listed in `PackageContents.xml`, or `Platform` mismatch |
| Command not found | Global name in the CUIX macro must match `<Command Global=…>` |
| Duplicate panels on upgrade | Bump `AppVersion`; keep `UpgradeCode` constant |
| Icons missing | Ship 16×16 and 256×256 in `Resources/`; `PackageContents.xml` references `./Resources/icon.png` |
| Placeholder contact | `CompanyDetails Email` must be a mailbox that actually delivers |
