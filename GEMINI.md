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
*   **Joinery:**
    *   confirmat_screw_length = 49
    *   confirmat_hole_diameter = 4
    *   confirmat_hole_edge_distance = 50

### Structure

*   **Corpus:** The corpus is made of `melanine_thickness_main` thick melanine and consists of two sides, a top, a bottom and a middle plate. The corpus is divided into two compartments. The bottom compartment contains six drawers and the top compartment is a bookcase with two shelves.
*   **Drawers:** The drawers are made of `melanine_thickness_secondary` thick melanine and are mounted to the sides of the corpus with slides. Each drawer has a front panel made of `melanine_thickness_main` thick melanine.
*   **Shelves:** The bookcase has two shelves made of `melanine_thickness_main` thick melanine.
*   **Joinery:** Confirmat screws (4.8mm x 49mm) are used to join the corpus panels and shelves. 4mm pilot holes for these screws are included in the model. The drawer components are also joined with these screws, with the number of screws depending on the panel length (2 for <50cm, 3 for >=50cm) and placed 5cm from the edge. Wooden dowels (phi 6 mm x 30 mm) are used to join the front panels to the drawer boxes.

## Changelog

### v2

*   The drawer assembly has been fixed. The back panel of the drawer is now correctly positioned.
*   The model has been made more parametric.
*   Added 4mm pilot holes for confirmat screws to join the drawer components.
*   The file `prompt/model-v2.md` has been added to reflect the changes in the model.

## Usage

To view the 3D model, open the `model.scad` file in [OpenSCAD](https://openscad.org/).