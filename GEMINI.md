# Gemini Project: Chest of Drawers Bookcase

This project contains the OpenSCAD code for a chest of drawers with an integrated bookcase.

## Files

*   `model.scad`: The main OpenSCAD file containing the 3D model of the furniture.
*   `prompt/model.md`: The detailed instructions and dimensions used to generate the `model.scad` file.
*   `prompt/model-v2.md`: The updated instructions and dimensions for the v2 model.
*   `artifacts/conversation.md`: A log of the conversation with the user.

## Model Description

The 3D model is a chest of drawers with an integrated bookcase. The design is parametric and all dimensions are derived from the main dimensions.

### Main Dimensions

*   **Corpus:**
    *   corpus_height = 2300
    *   corpus_width = 800
    *   corpus_depth = 230
*   **Melanine material thickness:**
    *   melanine_thickness_main = 19
    *   melanine_thickness_secondary = 12
*   **HDF Back Panel:**
    *   hdf_thickness = 3
*   **Pedestal:**
    *   pedestal_height = 30
*   **Shelves:**
    *   shelf_width = corpus_width - 2*melanine_thickness_main
    *   shelf_depth = corpus_depth
*   **Slides:**
    *   slide_width = 200
    *   slide_height = 45
    *   slide_depth = 13
*   **Drawers:**
    *   drawer_height = 200
    *   drawer_body_height = drawer_height - melanine_thickness_secondary
    *   drawer_depth = corpus_depth - 5
    *   drawer_width = shelf_width - 2*slide_depth
    *   drawer_body_width = drawer_width - 2*melanine_thickness_secondary
    *   drawer_bottom_offset = 10
    *   drawer_gap = 10
*   **Drawer Fronts:**
    *   front_gap = 3
    *   front_overhang = 3
    *   front_margin = 1.5
    *   front_width = corpus_width - 2 * front_margin
    *   front_height_base = drawer_height + drawer_gap - front_gap
    *   front_height_first = melanine_thickness_main + drawer_bottom_offset - front_gap + front_height_base
    *   front_height_standard = front_height_base
    *   front_height_top = front_height_standard + 3*front_overhang
*   **Bookcase Glass Doors:**
    *   bookcase_glass_door_width = (corpus_width - (1 + front_gap + 1))/2
    *   bookcase_glass_door_height = melanine_thickness_main + bookcase_shelf_gap + melanine_thickness_main + bookcase_shelf_gap + melanine_thickness_main/2
    *   bookcase_glass_door_tickness = 4
*   **Joinery:**
    *   confirmat_screw_length = 49
    *   confirmat_hole_diameter = 4
    *   confirmat_hole_edge_distance = 50
    *   dowel_diameter = 6
    *   dowel_length = 30
    *   dowel_hole_depth_in_front = 10
    *   dowel_hole_edge_distance = 50
    *   panel_length_for_four_dowels = 500
    *   slide_pilot_hole_depth = 2
    *   slide_pilot_hole_diameter = 2.5
    *   drawer_slide_pilot_hole_offsets = [35, 163]
    *   corpus_slide_pilot_hole_offsets = [6.5, 35, 51, 76, 99, 115]

### Structure

*   **Corpus:** The corpus is made of `melanine_thickness_main` thick melanine and consists of two sides, a top, a bottom and a middle plate. The corpus is divided into two compartments. The bottom compartment contains six drawers and the top compartment is a bookcase with two shelves.
*   **Drawers:** The drawers are made of `melanine_thickness_secondary` thick melanine and are mounted to the sides of the corpus with slides. Each drawer has a front panel made of `melanine_thickness_main` thick melanine. Dowel holes are included in the side and bottom panels for joining with the front panels. The drawer assembly has been fixed, and handle holes have been added to the drawer fronts.
*   **Shelves:** The bookcase has two shelves made of `melanine_thickness_main` thick melanine.
*   **HDF Back Panel:** A 3mm HDF back panel is attached to the back of the corpus.
*   **Pedestal:** A 30mm high pedestal is placed under the corpus.
*   **Glass Doors:** The bookcase section is enclosed by two glass doors.
*   **Joinery:** Confirmat screws (4.8mm x 49mm) are used to join the corpus panels and shelves. 4mm pilot holes for these screws are included in the model. The drawer components are also joined with these screws, with the number of screws depending on the panel length (2 for <50cm, 3 for >=50cm) and placed 5cm from the edge. Wooden dowels (phi 6 mm x 30 mm) are used to join the front panels to the drawer boxes. The front's blind hole is 1cm deep. There are two dowels per panel per side if the panel length is less than 50cm, and four dowels if longer, with even spacing. The hole locations are 5cm from the edge. Pilot holes for mounting the drawer slides are included in both the drawer sides and the corpus sides. These holes are 2mm deep and 2.5mm in diameter. In drawer sides, there are two holes per slide, located 35mm and 163mm from the front edge. ... In corpus sides, there are six holes per slide, located 6.5mm, 35mm, 51mm, 76mm, 99mm, and 115mm from the front edge.

### Cut List Generation

The model can generate a CSV cut list for all panels. This is controlled by the `generate_cut_list_csv` variable in `model.scad`. A PowerShell script, `generate-csv.ps1`, is provided to automate the process of generating the `artifacts/cut_list.csv` file.

## Changelog

### v2

*   The drawer assembly has been fixed. The back panel of the drawer is now correctly positioned.
*   The model has been made more parametric.
*   Added 4mm pilot holes for confirmat screws to join the drawer components.
*   The file `prompt/model-v2.md` has been added to reflect the changes in the model.
*   Added handle holes to drawer fronts.
*   Added transparency to the model for better visualization.
*   Added pilot holes for drawer slides in the corpus sides.
*   Added a configurable exploded view to visualize the assembly.
*   Added an HDF back panel to the corpus.
*   Added a pedestal to the bottom of the corpus.
*   Added glass doors to the bookcase section.
*   Added a feature to generate a CSV cut list.
*   Replaced the batch script for CSV generation with a more robust PowerShell script.

## Usage

To view the 3D model, open the `model.scad` file in [OpenSCAD](https://openscad.org/).