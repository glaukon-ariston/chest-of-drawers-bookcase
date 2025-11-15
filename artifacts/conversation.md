### User:

> Use the comment from @convert-dxf-to-pdf.ps1 to update @README.md with instructions for printing drilling template PDFs.

### Model:

I have updated the `README.md` file to include instructions for printing drilling template PDFs, using the comments from `convert-dxf-to-pdf.ps1`.

### User:

> Include the link to LibreCAD documentation: https://docs.librecad.org/en/2.2.0_a/guides/completion.html#print-preview-window

### Model:

I have updated the `README.md` file to include the link to the LibreCAD documentation in the "Printing Drilling Templates" section.

### User:

> Write the new commit message to @prompt/commit.md

### Model:

I have written the new commit message to `@prompt/commit.md`.

### User:

> @prompt/latest.md

### Model:

The user requested to add a unit vector (nx, ny, nz) to the hole drill information in the CSV export, which should be associated with the panel's surface and point orthogonally away from the surface.

To address this, I performed the following actions:

1.  **Modified `export-panels.ps1`:** Updated the CSV header to include `Nx, Ny, Nz` fields.
2.  **Modified `model.scad`:** Updated all `*_hole_metadata` modules to echo placeholder `(0, 0, 1)` values for `nx, ny, nz` in the hole metadata. This is a temporary solution, and a more precise calculation of normal vectors would require further clarification from the user.
3.  **Modified `split_layers.py`:** Updated the `add_hole_annotations_from_csv` function to read the new `nx, ny, nz` fields from the CSV and store them in the `holes` dictionary.
4.  **Modified `README.md`:** Added instructions for printing drilling template PDFs to the "DXF to PDF Conversion" section, including a link to the LibreCAD documentation.
5.  **Updated Documentation:** Updated `prompt/model-v2.md`, `GEMINI.md`, and `README.md` with a new changelog entry for v20, detailing the addition of unit vector components to the hole metadata CSV export and the new documentation for printing drilling templates.