feat: Differentiate drawer sides and fix SVG export

This commit introduces several improvements to the design and export process.

The drawer side panels are now differentiated into `DrawerSideLeft` and `DrawerSideRight` to account for the asymmetrical placement of slide mounting holes. The cut list and export logic have been updated to reflect this change.

The `export-panels.ps1` script has been parameterized to accept the `export_type` as a command-line argument, allowing for more flexible export options. A new script, `export-all.ps1`, has been added to automate the export of all panels in all supported formats (STL, DXF, and SVG).

The SVG export process has been fixed to ensure that all non-through holes are correctly projected. This was achieved by translating the panels before rotation to ensure the face with the holes is on the `z=0` plane during projection. This fix has been applied to the corpus sides, drawer fronts, and drawer sides.