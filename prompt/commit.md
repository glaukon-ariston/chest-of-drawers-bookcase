feat(model): Center drawer front dowel holes

This commit fixes a bug in the model where the dowel holes on the drawer fronts were not correctly aligned with the center of the drawer side panels. They were previously aligned to the inner face of the side panels.

Key changes:
- **`model.scad`**:
    - In `drawer_front_drill` and `drawer_front_hole_metadata`, the X-coordinate calculation for the side panel dowel holes has been adjusted. It now correctly offsets the holes from the inner face position by half of `melanine_thickness_secondary` to perfectly center them.
- **`test/test-drawer-front-alignment.ps1`**:
    - A new test script has been added to programmatically verify the X-axis alignment of the drawer front holes. This test exports the `DrawerFrontStandard` panel, parses the hole metadata, and asserts that the X-coordinates match the calculated center positions.
- **Documentation**:
    - The `README.md`, `GEMINI.md`, and `prompt/model-v2.md` files have been updated with a new changelog entry (v27) to reflect this fix and the addition of the new test script.
