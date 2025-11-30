feat(template): Add DrawerFrontOutsideTemplate panel and improve drill markers

Adds a new `DrawerFrontOutsideTemplate` panel to the model. This template has the same dimensions as the `DrawerFrontStandard` panel and includes all the holes. The `DrawerFrontTemplate` has been renamed to `DrawerFrontInsideTemplate`.

Drill markers in the DXF export have been improved. Crosshair markers for drilling holes are now enclosed in a 3mm circle to make them easier to aim and position.

The following changes were made:
- **`model.scad`**:
  - Added `DrawerFrontOutsideTemplate` module and related drill and metadata modules.
  - Renamed `DrawerFrontTemplate` to `DrawerFrontInsideTemplate`.
  - Updated `panel_names` list, `echo_hole_metadata`, `generate_cut_list`, and `export_panel` modules.
- **`split_layers.py`**:
  - Modified `add_hole_annotations_from_csv` to draw a 3mm circle around the crosshair markers for both side-drilled and planar holes.
  - Moved the crosshair for side-drilled holes to the `DRILL_MARKS` layer.
- **Documentation**:
  - Updated changelogs in `README.md`, `GEMINI.md`, and `prompt/model-v2.md` to reflect the changes.
