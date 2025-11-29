feat(template): Add handle holes to DrawerFrontTemplate

Adds 4mm handle holes to the `DrawerFrontTemplate` panel. These holes are identical to the ones on the `DrawerFrontStandard` panel.

The following changes were made:
- **`model.scad`**:
  - Added handle holes to the `drawer_front_template_hole_metadata` and `drawer_front_template_drill` modules.
  - Reverted an unintended change to `drawer_side_template_hole_metadata` where `confirmat_hole_edge_distance` was replaced with a hardcoded value.
- **`test/test-drawer-front-template.ps1`**:
  - Added a new test script to verify the export of the `DrawerFrontTemplate` panel.
- **Documentation**:
  - Updated changelogs in `README.md`, `GEMINI.md`, and `prompt/model-v2.md` to reflect the changes.
