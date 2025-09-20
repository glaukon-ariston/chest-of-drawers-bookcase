feat: Add new template panels and improve DXF export

This commit introduces several new features and improvements to the project.

- **New Template Panels:**
    - Added `PedestalSideTemplate`, `DrawerBackTemplate`, and `DrawerSideTemplate` to the `model.scad` file. These templates will be used for drilling holes.
    - The `panel_names` list, `echo_hole_metadata` module, `export_panel` module, and `generate_cut_list` module have been updated to include these new templates.
- **DXF Export Improvements:**
    - The line weight of the layers in the DXF files has been increased to make them more visible in the generated PDFs.
    - The dimension text is now placed above the dimension line, and the line does not cross over the text.
- **Bug Fixes:**
    - Fixed missing slide mount pilot holes in `DrawerSideTemplate`.

---
- `model.scad`:
    - Added new template panels: `PedestalSideTemplate`, `DrawerBackTemplate`, and `DrawerSideTemplate`.
    - Updated `panel_names` list to include the new template panels.
    - Updated `echo_hole_metadata` module to include the new template panels.
    - Updated `export_panel` module to include the new template panels.
    - Updated `generate_cut_list` module to include the new template panels.
    - Corrected the `DrawerSideTemplate_drill` and `drawer_side_template_hole_metadata` modules to include the pilot holes for the slides.
- `split_layers.py`:
    - Set the `lineweight` property for the `CUT`, `DRILL`, `DIMENSION`, and `ANNOTATION` layers to make the lines thicker in the generated PDFs.
    - Changed the `dimtad` setting to `1` to place the dimension text above the dimension line.
    - Changed the `dimtmove` setting to `2` to allow the dimension text to be moved freely.
- `README.md`:
    - Updated the changelog to v15.
- `GEMINI.md`:
    - Updated the changelog to v15.
- `prompt/model-v2.md`:
    - Updated the "Template Panels" section to include the new templates.
- `artifacts/conversation.md`:
    - Updated with the recent conversation.