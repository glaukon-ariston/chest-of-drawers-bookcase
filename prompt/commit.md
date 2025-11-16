feat: Improve OpenSCAD output and script robustness

This commit introduces several improvements to the OpenSCAD model, PowerShell scripts, and DXF export process.

- **Model Parameterization:**
    - Updated `drawer_slide_pilot_hole_offsets` from `[35, 163]` to `[37, 165]` in `model.scad`.

- **OpenSCAD Output:**
    - Added a `model_info` object to the console output for structured access to all critical model parameters.
    - Prefixed cut list entries with `CSV:` for easier and more reliable parsing by external scripts.
    - Prefixed panel names with `panel=` and the model identifier with `model_identifier=` in the console output to make parsing more robust.

- **PowerShell Scripts:**
    - All PowerShell scripts now use `Import-Module -Force` to ensure that the latest versions of the `CommonFunctions.psm1` module are always loaded, preventing issues with cached module versions.
    - The parsing logic in the `Get-ModelIdentifier` and `Get-PanelNames` functions in `CommonFunctions.psm1` has been improved to be more robust against variations in the OpenSCAD console output.

- **DXF Export:**
    - Removed the generation of 3D objects from the `pedestal_side_template_hole_metadata` module in `model.scad` to resolve DXF export issues.
    - The `split_layers.py` script has been updated to expect the `nx,ny,nz` unit vector components in the hole metadata CSV file.

- **Testing:**
    - Added new test scripts: `test/get-export-folder.ps1`, `test/export-panel.ps1`, and `test/get-panel-names.ps1` to facilitate testing of the export workflow.
    - Normalized the export folder path in `test/get-export-folder.ps1` to ensure consistency.

- **Documentation:**
    - Updated `README.md`, `GEMINI.md`, and `prompt/model-v2.md` to reflect the recent changes and design decisions.
