### Plan

1.  **Extract Hole Information from OpenSCAD:**
    *   I will modify the `model.scad` file to generate a companion data file (e.g., in JSON format) for each panel that is exported.
    *   This data file will contain detailed information about each hole on the panel, including its location (x, y coordinates), diameter, and depth. This is necessary because the 2D DXF export from OpenSCAD doesn't retain depth information for holes.

2.  **Enhance the DXF Processing Script:**
    *   I will update the `split_layers.py` script, which already processes the exported DXF files.
    *   I will add functionality to this script to read the new hole data files.
    *   Using this data, the script will add the required annotations to the DXF files:
        *   A legend explaining the symbols or text used for different hole types.
        *   Dimension lines and text labels for each hole, indicating its location, diameter, and depth (e.g., "∅ 5mm, 10mm deep").

3.  **Integrate into the Export Workflow:**
    *   I will ensure the updated scripts work together seamlessly within the existing `export-panels.ps1` workflow.
