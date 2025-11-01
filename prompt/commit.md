feat(dxf): Add template generation and drill marks

This commit introduces two new features to the DXF export workflow:

1.  **Drill Marks Layer:** A new `DRILL_MARKS` layer has been added to the DXF output. This layer contains black crosshair markers for all planar drill holes, providing a clear visual distinction from side-drilled holes, which are marked with blue crosshairs on the `DRILL` layer.

2.  **Template Generation:** A `--template` flag has been added to the `split_layers.py` script. When this flag is used, the script generates a clean DXF file that excludes dimension lines, title, legend, and the hole schedule. This is useful for creating printable drilling templates.

**File Changes:**

*   `split_layers.py`:
    *   Added a `DRILL_MARKS` layer definition.
    *   Modified `add_hole_annotations_from_csv` to add crosshairs to the `DRILL_MARKS` layer for planar holes.
    *   Updated `add_legend` to include a description of the new layer.
    *   Added a `--template` command-line flag to control the exclusion of annotations.
    *   Modified `split_layers` to conditionally generate annotations based on the `--template` flag.

*   `split-layers-dxf.ps1`:
    *   Added a new output directory `dxf-template` for the template files.
    *   Added a call to `split_layers.py` with the `--template` flag to generate the template files.

*   `convert-dxf-to-pdf.ps1`:
    *   Added `-dxfDir` and `-pdfDir` parameters to allow specifying input and output directories for PDF conversion.

*   `workflow.ps1`:
    *   Added a call to `convert-dxf-to-pdf.ps1` to convert the new `dxf-template` files to PDF.

*   `prompt/model-v2.md`, `GEMINI.md`, `README.md`:
    *   Updated with a new changelog entry for v18 and documentation for the new features.

*   `artifacts/conversation.md`:
    *   Updated with a summary of the recent conversation.