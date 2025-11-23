feat: Adjust drawer side hole position

This commit adjusts the position of the bottom hole on the drawer's side panels that connects to the back panel. The hole has been moved from 50mm to 35mm from the edge to prevent interference with the drawer slide mechanism.

This change is reflected in the following locations:
- `drawer_side_hole_metadata`: The Z-coordinate for the bottom back panel hole is now hardcoded to 35.
- `drawer_side_drill`: The Z-coordinate for the bottom back panel hole is now hardcoded to 35.
- `drawer_side_template_hole_metadata`: The Z-coordinate for the bottom back panel hole is now hardcoded to 35.

Additionally, the `drawer_slide_pilot_hole_offsets` has been updated from `[37, 165]` to `[37, 163]`.

The following files have been updated to reflect these changes:
- `prompt/model-v2.md`: Updated with a new changelog entry for v22 and the corrected `drawer_slide_pilot_hole_offsets` value.
- `GEMINI.md`: Updated with a new changelog entry for v22 and the corrected `drawer_slide_pilot_hole_offsets` value.
- `README.md`: Updated with a new changelog entry for v22 and the corrected `drawer_slide_pilot_hole_offsets` value.
- `artifacts/conversation.md`: Updated with the latest conversation.
- `prompt/commit.md`: Cleared and updated with this commit message.
- `model.scad`: The core change was implemented in this file.
