feat: Add corpus side pilot holes for drawer slides

This commit introduces pilot holes in the corpus sides for fixing drawer slides.

- Added common constants for pilot hole depth, diameter, and radius.
- Introduced `corpus_slide_pilot_hole_offsets` array for corpus side holes.
- Refactored drawer slide pilot holes to use `drawer_slide_pilot_hole_offsets` array.
- Modified `corpus_side` module to include pilot holes for drawer slides.
- Updated `corpus` module to correctly instantiate corpus sides.
- Updated `drawer_side` module to use array for drawer slide pilot hole offsets.
- Updated documentation (`model-v2.md`, `GEMINI.md`, `README.md`) to reflect these changes.