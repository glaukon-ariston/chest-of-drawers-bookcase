feat: Improve CNC export and hole metadata

This commit introduces several improvements to the CNC export workflow and the hole metadata generation.

- **Corrected Hole Coordinates:** The 2D hole coordinate calculation for DXF export has been fixed to resolve issues with reflected coordinates across different panels.

- **Panel Projections at Origin:** All exported 2D panels are now translated to start at the (0,0) origin and extend into the positive quadrant. This ensures consistency and predictability in the exported DXF files.

- **Hole Table in DXF:** The `split_layers.py` script now adds a detailed "Hole Schedule" table to the `ANNOTATION` layer of the DXF files. This table includes the hole name, diameter, depth, and its X, Y, and Z coordinates, providing comprehensive manufacturing data directly in the DXF file.

- **Corrected Z-Coordinate Representation:** The Z-coordinate in the hole metadata now correctly distinguishes between holes drilled perpendicularly into the panel face (z=0) and those drilled into the edge (z=half panel thickness). This provides more accurate information for CNC machining.