feat(dxf): Add normal vector to hole metadata and update docs

This commit introduces the export of normal vector components (nx, ny, nz) for each hole in the DXF metadata CSV. These values currently serve as placeholders (0, 0, 1) and will be refined in future iterations based on more specific requirements for determining the normal vector of the panel surface at the hole location.

Additionally, this commit updates the documentation to reflect the latest changes and improvements.

- `model.scad`:
    - Modified all `*_hole_metadata` modules to include placeholder `(0, 0, 1)` for `nx, ny, nz` in the `echo` statements.
- `export-panels.ps1`:
    - Updated the CSV header to include `Nx, Ny, Nz` fields.
- `split_layers.py`:
    - Updated `add_hole_annotations_from_csv` function to read the new `nx, ny, nz` fields from the CSV and store them in the `holes` dictionary.
- `README.md`:
    - Added instructions for printing drilling template PDFs to the "DXF to PDF Conversion" section, including a link to the LibreCAD documentation.
    - Added a new changelog entry for v20.
- `GEMINI.md`:
    - Added a new changelog entry for v20.
- `prompt/model-v2.md`:
    - Updated the "Hole Metadata Export" section to mention the `nx, ny, nz` fields.
    - Added a new changelog entry for v20.
- `artifacts/conversation.md`:
    - Appended a summary of the recent conversation.