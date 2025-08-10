feat: Add wooden dowel joinery for drawer fronts

This commit introduces wooden dowel joinery for attaching drawer fronts to the drawer box assembly.

- Added 6mm diameter, 30mm long dowel holes to drawer fronts, sides, and bottom panels.
- Implemented a 1cm blind hole depth in the drawer fronts.
- Ensured dowel hole locations are 5cm from the edge.
- Added logic for two dowels per panel per side if the panel length is less than 50cm, and four dowels if longer, with even spacing.
- Corrected the rotation of dowel holes in `drawer_side` and `drawer_bottom` modules to be perpendicular to the panels.
- Replaced the magic constant `500` with a descriptive constant `panel_length_for_four_dowels`.
- Updated `prompt/model-v2.md`, `GEMINI.md`, and `README.md` to document these changes.
