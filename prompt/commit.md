feat: Add handle holes and transparency to model

This commit introduces handle holes to drawer fronts and adds transparency for better visualization.

- Added `handle_hole_diameter` and `handle_hole_spacing` parameters.
- Implemented `handle_hole` module and integrated into `drawer_front`.
- Added `part_alpha` for transparency and applied to various modules.
- Updated `prompt/model-v2.md`, `GEMINI.md`, and `README.md` to document these changes.