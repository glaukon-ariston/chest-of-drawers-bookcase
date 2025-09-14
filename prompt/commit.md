feat: Refactor and enhance CNC export and order generation

This commit introduces a series of improvements to the CNC export workflow, order generation, and overall model accuracy.

- **Model Parameterization:** The main melamine thickness (`melanine_thickness_main`) has been adjusted from 19mm to 18mm to reflect the available material.

- **DXF Export and Annotations:**
    - The 2D projections for the `DrawerSideLeft`, `DrawerSideRight`, and `DrawerBack` panels have been corrected to ensure they are oriented correctly with the longer side horizontal and are placed in the first quadrant of the DXF file.
    - The corresponding hole metadata functions (`get_drawer_side_hole_2d_coords` and `get_drawer_back_hole_2d_coords`) have been updated to match the new panel orientations, ensuring that hole annotations are accurately placed.

- **Bug Fixes:**
    - Corrected the position of the rear confirmat screw hole on the drawer side panels, which was previously 62mm from the edge instead of the standard 50mm.
    - Fixed the projection of the `DrawerBack` panel, which was previously upside down.

- **Order Generation:**
    - The `create_order.py` script has been refactored to handle multiple materials for the Elgrad cutting service. The script now iterates through the materials in the cut list and generates a separate order file for each material.

- **Documentation and DXF Processing:**
    - The `export-panels.ps1` script has been updated with more detailed comments.
    - The `split_layers.py` script has been cleaned up by removing debug print statements.
    - The `TODO.md` file has been updated with new items for future development.
    - The `README.md`, `GEMINI.md`, and `prompt/model-v2.md` files have been updated to reflect all the recent changes.