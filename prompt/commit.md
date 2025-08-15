feat: Add cut list generation feature

This commit introduces a new feature to automatically generate a CSV cut list for all the panels required to build the furniture.

- A new module, `generate_cut_list()`, has been added to the `model.scad` file. This module, controlled by the `generate_cut_list_csv` flag, prints the cut list data to the OpenSCAD console.
- A PowerShell script, `generate-csv.ps1`, has been created to automate the process of generating the cut list. It runs OpenSCAD, captures the output, and saves the cleaned CSV data to `artifacts/cut_list.csv`.
- The previous batch script (`generate-csv.bat`) has been replaced by the more robust PowerShell script.
- The project documentation (`README.md`, `GEMINI.md`, and `prompt/model-v2.md`) has been updated to reflect the new feature and how to use it.