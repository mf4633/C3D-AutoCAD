# C3D Field Kit — partial CUIX / ribbon build notes

Autodesk requires every Marketplace plug-in to add a **ribbon panel** via a
**partial CUIX** file. Minimum: one panel on the **Plug-Ins** tab with at least
one button that runs a command or opens help.

---

## Target layout

**Tab:** Plug-Ins (existing AutoCAD tab)  
**Panel name:** `C3D Field Kit`  
**Panel ID:** `C3DFieldKit` (no spaces in internal ID)

### Suggested button groups (flyouts keep the panel compact)

| Flyout label | Buttons (command macro) |
|--------------|-------------------------|
| **Parcel** | `LABELACRES` · `TOTALAREA` · `TLEN` · `BD` · `BDTBL` |
| **Survey** | `NE` · `ZL` · `CENTROID` |
| **COGO** | `SLP` |
| **Text** | `MAKEUPPER` · `MAKELOWER` · `TITLECASE` · `CTH` · `TROT` · `SCALETXT` · `T2M` |
| **Z** | `FLAT` · `CHZ` · `GETZ` |
| **Layers** | `LI` · `LUI` · `LDEL` · `BC` |
| **Utilities** | `PLT` · `PA` · `ZO` |
| **Help** | Opens `quickstart.html` or runs `HELP` macro to bundled doc |

---

## Build procedure (Civil 3D)

1. Open Civil 3D → type **`CUI`** → Enter.
2. Right-click **Partial Customization Files** → **New Partial CUI File**.
3. Name it **`C3DFieldKit.cuix`**.
4. Under the new partial file:
   - **Ribbon** → **Tabs** → locate **Plug-Ins** tab (or create panel under it).
   - **New Panel** → name **C3D Field Kit**.
5. For each command button:
   - **Command List** (bottom) → **New Command**.
   - **Name:** e.g. `Label Acres`
   - **Macro:** `^C^CLABELACRES` (leading `^C^C` cancels any active command)
   - **Description:** copy from README table.
   - Drag command onto the panel (or into a flyout).
6. Assign icons from `Resources/icon_16.png` where possible.
7. **Apply** → **OK**.
8. **Transfer** tab → export/save the partial file to:

   ```
   marketplace/C3DFieldKit.bundle/C3DFieldKit.cuix
   ```

9. Reference the CUIX from `PackageContents.xml` (add after first successful test):

   ```xml
   <ComponentEntry AppName="C3DFieldKitUI"
     ModuleName="./C3DFieldKit.cuix"
     AppDescription="Ribbon panel"
     LoadOnAutoCADStartup="True"
     LoadOnCommandInvocation="False" />
   ```

   Place this entry in the `<Components>` block alongside the LISP entries.

---

## Macro cheat sheet

| Button | Macro |
|--------|-------|
| Label Acres | `^C^CLABELACRES` |
| Total Area | `^C^CTOTALAREA` |
| Total Length | `^C^CTLEN` |
| Bearing Distance | `^C^CBD` |
| BD Table | `^C^CBDTBL` |
| Slope | `^C^CSLP` |
| NE Label | `^C^CNE` |
| Z Label | `^C^CZL` |
| Flatten Z | `^C^CFLAT` |
| Plot All PDF | `^C^CPLT` |
| Help | `^C^C(startapp "explorer" "Help/quickstart.html")` *(adjust path after install)* |

---

## Common review failures

| Issue | Fix |
|-------|-----|
| No ribbon panel | Partial CUIX not listed in `PackageContents.xml` |
| Panel on wrong tab | Must be Plug-Ins (or dedicated tab if many panels) |
| Command not found | Global name in CUIX must match `Command Global=` in XML |
| Duplicate panels on upgrade | Bump `AppVersion`; use consistent `UpgradeCode` in XML |
| Icons missing | Ship 16×16 and 256×256 in `Resources/` |

---

## Optional: dedicated tab

If the panel feels crowded, Autodesk allows a **dedicated tab** named **C3D Field Kit**
with multiple panels (Parcel, Survey, Text, …). Use this if you add more commands later.