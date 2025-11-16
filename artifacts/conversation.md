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

### User:
> Make the following actions:
> - Use `git status` and `git diff` to get a comprehensive overview of all local changes and better understand their scope.
> - Update the @prompt/model-v2.md file with the recent changes and design decisions.
> - Update the @GEMINI.md file with the recent changes and design decisions.
> - Update the @README.md file with the recent changes and design decisions.
> - Update the @artifacts/conversation.md with our recent conversation. Do not delete content from @artifacts/conversation.md, just add to it. 
> - Clear the content of the @prompt/commit.md file.
> - Prepare the commit message for the recent changes in a raw format, without line numbers and extra indentation. Include detailed findings from `git status` and `git diff` to annotate the commit message for every changed source file. Write it to the @prompt/commit.md file.

### Model:
I have performed the requested actions.
I have reviewed the `git status` and `git diff` output and updated the `prompt/model-v2.md`, `GEMINI.md`, and `README.md` files with the recent changes and design decisions.
I have also cleared the content of the `prompt/commit.md` file and prepared a new commit message in `prompt/commit.md`.
I have appended our recent conversation to `artifacts/conversation.md`.
