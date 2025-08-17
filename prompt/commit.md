feat: Add DXF layering and analysis scripts

This commit introduces new scripts to enhance the DXF export workflow and provide tools for analyzing DXF files.

- A PowerShell script `split-layers-dxf.ps1` has been added to automate the process of separating DXF geometry into `CUT` and `DRILL` layers using the `split_layers.py` script.
- A Python script `analyze_dxf.py` has been added to analyze DXF files, providing a summary of layers and the number of entities on each layer. This script can analyze individual files or all DXF files within a specified directory.

Documentation has been updated to reflect these new tools and their usage.