feat(dxf): Add title and hole names to DXF export

This commit introduces two new features to the DXF export process:

- A title with the panel name is now added to the top of each DXF drawing.
- The hole name is now included in the hole annotations for easier identification.

These changes improve the clarity and usability of the generated DXF files, making them easier to understand and use for manufacturing.

### Changes

- `split_layers.py`:
    - Added `add_title()` function to add a title to the DXF drawing.
    - Modified `add_hole_annotations_from_csv()` to include the hole name in the annotation.
- `README.md`, `GEMINI.md`, `prompt/model-v2.md`:
    - Updated documentation to reflect the new features.
