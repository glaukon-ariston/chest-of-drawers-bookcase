### Plan to Add Hole Metadata and Annotations

1.  **`model.scad` - Expose Hole Metadata**
    *   A new global variable `hole_metadata` will be created to store information about each hole (panel name, hole name, coordinates, diameter, depth).
    *   A function `log_hole()` will be implemented to populate this `hole_metadata` array.
    *   The existing modules that create holes will be modified to call `log_hole()`.
    *   When a panel is exported, the script will echo the collected `hole_metadata` to the console in a machine-readable format (pipe-delimited). This will be triggered by the `export_panel_name` variable not being empty.

2.  **`export-panels.ps1` - Capture and Persist Metadata**
    *   The script will be updated to capture the console output from OpenSCAD during the DXF export process.
    *   It will parse this output to extract the hole metadata table.
    *   For each panel, a corresponding CSV file (e.g., `CorpusSideLeft.csv`) will be created in the `artifacts/export/dxf` directory. This file will contain the hole metadata for that specific panel.

3.  **`split_layers.py` - Generate DXF Annotations**
    *   The Python script will be modified to look for a companion CSV file for each DXF file it processes.
    *   If a CSV file is found, the script will:
        *   Read the hole data from the CSV.
        *   Create a new layer in the DXF file named `ANNOTATION`.
        *   For each hole, it will add a text annotation on the `ANNOTATION` layer at the specified X and Y coordinates. The annotation text will display the hole's diameter and depth (e.g., "D5 d10").

This approach avoids the limitations of OpenSCAD's text rendering for projections and leverages the existing scripting infrastructure to enrich the DXF files with manufacturing details.
