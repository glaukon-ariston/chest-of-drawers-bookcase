feat: Add Sizekupres order support and fix DXF export bug

This commit introduces several updates to the project.
- Adds support for the 'Sizekupres' cutting service to the order generation script.
- Integrates order generation for all supported services into the main `workflow.ps1` script.
- Fixes a critical bug in `split_layers.py` that prevented correct identification and deletion of `LINE` entities for holes.

### create_order.py
- Added a new `sizekupres` entry to the `MATERIAL` dictionary with material and edge banding codes.
- Implemented the `process_sizekupres_order` function to handle the specific format of the Sizekupres order template.
- The main execution logic is now encapsulated in a `main()` function.
- The `verify_header` function was made more flexible to only check for an expected prefix in the header.

### split_layers.py
- Refactored the logic for mapping polylines to line segments into a new function `map_polyline_to_line_segments`.
- Fixed a bug in this mapping by adding a tolerance to the `isclose()` checks, which resolves the issue of `LINE` entities not being correctly identified due to floating-point inaccuracies.
- Added a `DELETED` layer for diagnostic purposes.
- The deletion logic was temporarily changed to move entities to the `DELETED` layer to help debug the issue.
- The radius of the created circles is now rounded.

### workflow.ps1
- The script now automatically generates order files for all supported cutting services (`iverpan`, `elgrad`, `sizekupres`).
- The order of operations was slightly adjusted.

### order/template/
- New and modified templates for the Sizekupres service.

### Documentation
- Updated changelogs and documentation in `README.md`, `GEMINI.md`, and `prompt/model-v2.md` to reflect the new features and bug fixes.