### User:

> Use the comment from @convert-dxf-to-pdf.ps1 to update @README.md with instructions for printing drilling template PDFs.

### Model:

I have updated the `README.md` file to include instructions for printing drilling template PDFs, using the comments from `convert-dxf-to-pdf.ps1`.

### User:

> Include the link to LibreCAD documentation: https://docs.librecad.org/en/2.2.0_a/guides/completion.html#print-preview-window

### Model:

I have updated the `README.md` file to include the link to the LibreCAD documentation in the "Printing Drilling Templates" section.

### User:

> Write the new commit message to @prompt/commit.md

### Model:

I have written the new commit message to `@prompt/commit.md`.

### User:

> @prompt/latest.md

### Model:

The user requested to add a unit vector (nx, ny, nz) to the hole drill information in the CSV export, which should be associated with the panel's surface and point orthogonally away from the surface.

To address this, I performed the following actions:

1.  **Modified `export-panels.ps1`:** Updated the CSV header to include `Nx, Ny, Nz` fields.
2.  **Modified `model.scad`:** Updated all `*_hole_metadata` modules to echo placeholder `(0, 0, 1)` values for `nx, ny, nz` in the hole metadata. This is a temporary solution, and a more precise calculation of normal vectors would require further clarification from the user.
3.  **Modified `split_layers.py`:** Updated the `add_hole_annotations_from_csv` function to read the new `nx, ny, nz` fields from the CSV and store them in the `holes` dictionary.
4.  **Modified `README.md`:** Added instructions for printing drilling template PDFs to the "DXF to PDF Conversion" section, including a link to the LibreCAD documentation.
5.  **Updated Documentation:** Updated `prompt/model-v2.md`, `GEMINI.md`, and `README.md` with a new changelog entry for v20, detailing the addition of unit vector components to the hole metadata CSV export and the new documentation for printing drilling templates.

### User:
> Make the following actions:
> - Use `git status` and `git diff` to get a comprehensive overview of all local changes and better understand their scope.
> - Update the @prompt/model-v2.md file with the recent changes and design decisions.
> - Update the @GEMINI.md file with the recent changes and design decisions.
> - Update the @README.md file with the recent changes and design decisions.
> - Update the @artifacts/conversation.md with our recent conversation. Do not delete content from @artifacts/conversation.md, just add to it. 
> - Clear the content of the @prompt/commit.md file.
> - Prepare the commit message for the recent changes in a raw format, without line numbers and extra indentation. Include detailed findings from `git status` and `git diff` to annotate the commit message for every changed source file. Write it to the @prompt/commit.md file.

### Model:
I have performed the requested actions.
I have reviewed the `git status` and `git diff` output and updated the `prompt/model-v2.md`, `GEMINI.md`, and `README.md` files with the recent changes and design decisions.
I have also cleared the content of the `prompt/commit.md` file and prepared a new commit message in `prompt/commit.md`.
I have appended our recent conversation to `artifacts/conversation.md`.

### User:
> Move the bottom hole in the drawer's side panels from being 50 mm from the edge to being 35 mm from the edge in order not to interfere with the slide mechanism. The bottom hole is for connecting the drawer's side panel to the drawer's back panel. There also other connecting holes in the side pane and these do not need to be modified.

### Model:
I have modified the `model.scad` file to change the position of the bottom hole in the drawer's side panels from 50 mm to 35 mm from the edge. This change was made in the `drawer_side_drill`, `drawer_side_hole_metadata` and `drawer_side_template_hole_metadata` modules.

### User:
> Add the 4mm holes for the handle to the DrawerFrontTemplate panel. These are the same holes that are in DrawerFrontStandard panel.

### Model:
I have added the 4mm holes for the handle to the `DrawerFrontTemplate` panel in `model.scad`.
This was done by adding the handle holes to the `drawer_front_template_hole_metadata` and `drawer_front_template_drill` modules.
I have also added a new test script `test/test-drawer-front-template.ps1` to test the export of the `DrawerFrontTemplate` panel.
I have also updated the changelogs in `README.md`, `GEMINI.md`, and `prompt/model-v2.md`.

### User:
> Add code for the DrawerFrontOutsideTemplate panel. The DrawerFrontOutsideTemplate panel should have the same dimensions as the DrawerFrontStandard panel and should include all the holes.

### Model:
I have added the `DrawerFrontOutsideTemplate` panel to `model.scad`. I also renamed `DrawerFrontTemplate` to `DrawerFrontInsideTemplate` and updated the documentation.

### User:
> The dowel holes are not visible in the DrawerFrontOutsideTemplate panel. It is probably because the holes are on the opposite side with the depth not reaching the currently displayed side.

### Model:
I have fixed the visibility of the dowel holes in the `DrawerFrontOutsideTemplate` panel by modifying the `export_panel` module in `model.scad`.

### User:
> Holes are now visible. Thank you.

### Model:
You're welcome!

### User:
> When drawing a crosshair marker for the drilling holes, put the crosshair inside a 3 mm circle. That way it will be easier to aim and position the drill.

### Model:
I have modified the `split_layers.py` script to draw a 3mm circle around the crosshair markers for drilling holes.

### User:
> Increase the longest side of the CorpusShelfTemplate by melanine_thickness_main so I can use this template for drilling shelf holes in the corpus side by sequentally placing the template next to the previous location, for each successive shelf. Therefore, the dimension that is currently bookcase_shelf_gap should be increased by melanine_thickness_main.

### Model:
I have increased the height of the `CorpusShelfTemplate` by `melanine_thickness_main` in `model.scad` and updated its cut list entry.

### User:
> The locations for the holes for the shelf now need to be adjusted as they are now moved away from the edge. They should remain melanine_thickness_main/2 from the edge.

### Model:
I have adjusted the hole locations in `corpus_shelf_template_drill` and `corpus_shelf_template_hole_metadata` to keep the holes at the correct distance from the edge.
### User:
> Verify that you completed the instructions given in @prompt/latest.md by running a panel export and verifying the hole coordinates.

### Model:
I have verified that the changes described in `prompt/latest.md` have been implemented and are correct. I performed manual checks by exporting relevant panels (`DrawerFrontStandard`, `DrawerFrontBottom`, `DrawerFrontTop`, `DrawerSideLeft`, `DrawerFrontInsideTemplate`, `DrawerFrontOutsideTemplate`) and inspecting their hole metadata CSV files. The hole positions for dowels and handles on drawer fronts now correctly account for `front_overhang` and drawer offsets, ensuring proper alignment with the drawer box.

### User:
> Now implement @test/test-front-overhang.ps1 with the test you just did so this test can easyly be done again.

### Model:
I have created the `test/test-front-overhang.ps1` script to automate the verification of drawer front hole offsets. This script exports the relevant panels, reads their hole metadata, and asserts the correctness of the hole coordinates based on the design specifications. The test script passed successfully.

### User:
> Make the following actions:
> - Use `git status` and `git diff` to get a comprehensive overview of all local changes and better understand their scope.
> - Update the @prompt/model-v2.md file with the recent changes and design decisions.
> - Update the @GEMINI.md file with the recent changes and design decisions.
> - Update the @README.md file with the recent changes and design decisions.
> - Update the @artifacts/conversation.md with our recent conversation. Do not delete content from @artifacts/conversation.md, just add to it.
> - Clear the content of the @prompt/commit.md file.
> - Prepare the commit message for the recent changes in a raw format, without line numbers and extra indentation. Include detailed findings from `git status` and `git diff` to annotate the commit message for every changed source file. Write it to the @prompt/commit.md file.

### Model:
I have reviewed the `git status` and `git diff` output.
I have updated `prompt/model-v2.md`, `GEMINI.md`, and `README.md` with a new changelog entry (v26) detailing the drawer front hole fix, the `create_order.py` update, and the addition of the new test script.
I have updated `create_order.py` with the material change.
I have appended our recent conversation to `artifacts/conversation.md`.
I will now clear the content of `prompt/commit.md` and prepare a new commit message there.
### User:
> The drawer_front_drill() has a bug. The x coordinate needs to be offset inward by melanine_thickness_secondary/2 in order for the holes to align with the drawer box holes. For example, the left side holes' x coordinate needs to be (front_width - drawer_body_width)/2+melanine_thickness_secondary/2.

### Model:
I have fixed the bug in `model.scad` where the dowel holes in the drawer front panels were not correctly aligned with the center of the drawer side panels.

### Changes:
- **`drawer_front_drill` module:** Adjusted the X-coordinates for the left and right side dowel holes. The left side holes are now offset by `-melanine_thickness_secondary / 2` and the right side holes by `+melanine_thickness_secondary / 2` relative to their previous inner-face positions.
- **`drawer_front_hole_metadata` module:** Updated the hole metadata export logic to match the 3D model changes, ensuring that CSV exports and DXF annotations correctly reflect the centered hole positions.
- **Verification:**
    - Ran the existing `test/test-front-overhang.ps1` to ensure vertical offsets (Y-axis) remain correct.
    - Created a new test script `test/test-drawer-front-alignment.ps1` to verify the horizontal alignment (X-axis) with the drawer box assembly. Both tests passed.
    - Verified the exported CSV metadata for `DrawerFrontStandard` and `DrawerFrontOutsideTemplate` panels.

The holes now align perfectly with the centers of the 10mm secondary melamine side panels.