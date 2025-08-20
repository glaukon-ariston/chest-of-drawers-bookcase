feat: Add hole annotations to DXF export

This feature adds annotations for hole dimensions and locations to the DXF export workflow.

The annotations are generated as text labels on a separate `ANNOTATION` layer in the DXF file. Each label specifies the diameter and depth of the hole (e.g., "d4 h19").

A legend is also added to the DXF file to explain the different layers (`CUT`, `DRILL`, `ANNOTATION`) and the format of the annotations.

This makes the DXF files more informative and easier to use for manual drilling or for verifying CNC toolpaths.

The following changes were made:
- Added a `show_hole_annotations` flag to `model.scad` to control the visibility of the annotations.
- Added `..._annotations` modules to `model.scad` to generate the annotation text.
- Updated the `split_layers.py` script to handle the new `ANNOTATION` layer and to add a legend to the DXF files.
- Updated the documentation to reflect the new feature.