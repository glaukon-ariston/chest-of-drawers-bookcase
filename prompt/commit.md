feat: Add CNC export workflow

This commit introduces a new workflow for exporting the 2D panel drawings in DXF format, suitable for CNC cutting services.

- A PowerShell script, `export-panels.ps1`, has been added to automate the export of all panels from the `model.scad` file.
- A Python script, `split_layers.py`, has been added to post-process the exported DXF files and separate the geometry into `CUT` and `DRILL` layers.
- The `model.scad` file has been updated to support the new export workflow.
- The project documentation (`README.md`, `GEMINI.md`, and `prompt/model-v2.md`) has been updated to reflect the new CNC export workflow.