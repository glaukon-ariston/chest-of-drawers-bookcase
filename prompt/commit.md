feat: Implement drawer front hole offset and update order materials

This commit introduces a fix for the vertical offset of dowel and handle holes in drawer front panels, ensuring correct alignment with drawer box components. It also updates the material code for HDF panels in the Iverpan order generation. A new PowerShell test script is added to verify these changes.

- **model.scad**:
    - Refactored `drawer_front_hole_metadata`, `drawer_front_drill`, and `drawer_front` modules to include a `box_bottom_offset` parameter.
    - Updated calls to these modules (`echo_hole_metadata`, `drawer_front_outside_template_drill`, `draw_fronts`, `export_panel`) to correctly pass `box_bottom_offset` based on the specific drawer front (standard, top, or bottom) and its vertical positioning relative to the drawer box. This addresses the issue where dowel and handle holes were incorrectly aligned due to not accounting for `front_overhang` and other vertical offsets.

- **create_order.py**:
    - Modified material definition for the 'iveral' service to change `HDF-3` from `HDF-3-Hrast` to `HDF-3-Bijela`.

- **test/test-front-overhang.ps1**:
    - Added a new PowerShell script to systematically verify the correct vertical positioning of holes in drawer front panels and their templates.
    - Tests cover `DrawerFrontStandard`, `DrawerFrontBottom`, `DrawerFrontTop`, `DrawerSideLeft`, `DrawerFrontInsideTemplate`, and `DrawerFrontOutsideTemplate`.

- **prompt/latest.md**:
    - Updated with the prompt detailing the drawer front hole offset issue.

- **GEMINI.md, README.md, prompt/model-v2.md**:
    - Updated changelogs to include a new entry (v26) summarizing the bug fixes and new test script.

- **artifacts/openscad-console.log**:
    - Updated due to re-running OpenSCAD for testing.

- **artifacts/model.png**:
    - Updated due to changes in `model.scad` and subsequent re-rendering.