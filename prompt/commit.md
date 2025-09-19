feat: Add template panels and improve DXF export

This commit introduces several improvements to the DXF export process and adds new template panels for easier manufacturing.

**New Features:**

- **Template Panels:** Added three new template panels to the `model.scad` file:
    - `CorpusSideSlideTemplate`: For drilling slide mounting pilot holes.
    - `DrawerFrontTemplate`: For drilling dowel mounting holes for the front panel.
    - `CorpusShelfTemplate`: For drilling shelf mounting holes.
- **Hole Metadata:** Added hole metadata export for the new template panels.
- **DXF Statistics:** The `split_layers.py` script now generates and prints statistics about the entity types and their sizes in the source DXF file.

**Bug Fixes:**

- **Hole Generation:** Fixed issues where holes were not appearing on the template panels due to being created at the surface boundary.
- **Panel Orientation:** Corrected the 2D projection of `CorpusSideSlideTemplate` and `CorpusShelfTemplate` to ensure they are in the first quadrant with the lower-left corner at the origin.
- **Circle Export:** Implemented a workaround in `split_layers.py` to convert circle-like polylines exported by OpenSCAD into true `CIRCLE` entities in the final DXF file. This addresses the issue of holes being represented as segmented lines.
- **ARC to DRILL:** Small `ARC` entities are now correctly classified to the `DRILL` layer.

**Refactoring:**

- **`model.scad`:**
    - Increased the `$FN` variable to 100 to improve the resolution of circles in the DXF export.
- **`split_layers.py`:**
    - Changed the `DIMENSION` layer color to grey and the `ANNOTATION` layer color to black for better visibility.

**Documentation:**

- Updated `README.md`, `GEMINI.md`, and `prompt/model-v2.md` to reflect the recent changes.