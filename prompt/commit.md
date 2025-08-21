feat: Add hole metadata export and DXF annotation

This commit introduces a new feature to export detailed hole metadata from the OpenSCAD model and use it to generate annotations in the DXF files.

- In `model.scad`, added a mechanism to echo hole metadata (panel name, hole name, 2D projected coordinates, diameter, and depth) to the console during panel export.
- The `export-panels.ps1` script is updated to parse this metadata and create a corresponding CSV file for each exported panel.
- The `split_layers.py` script now reads the CSV file and adds text annotations for each hole on a new `ANNOTATION` layer in the DXF file.

This provides a fully automated workflow for generating richly annotated DXF files, ready for manufacturing, directly from the OpenSCAD model.