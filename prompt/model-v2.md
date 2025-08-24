# Chest of Drawers Bookcase: Model Description

This document provides a detailed description of the OpenSCAD model for the chest of drawers with an integrated bookcase. It outlines the design decisions, parametric setup, and modular structure of the `model.scad` file.

## 1. Overview

The model is a piece of furniture combining a six-drawer chest of drawers with a bookcase on top. The design is fully parametric, meaning the entire model can be resized by changing a few key variables. The model is built in a modular way in OpenSCAD, allowing for easy customization and debugging. The model also includes transparency for better visualization.

## 2. Parametric Design

The model is driven by a set of global parameters defined at the beginning of the `model.scad` file. This allows for easy modification of the overall dimensions and material thicknesses. The variable names are chosen to be descriptive for better readability.

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
    *   number_of_drawers = 6
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

All other dimensions for components like shelves, drawer parts, and front panels are derived from these base parameters.

## 3. Component Breakdown

The model is broken down into several distinct components, each with its own OpenSCAD module for easy identification and manipulation.

### 3.1. Corpus

-   The main body of the furniture.
-   Consists of two side panels, a top plate, a bottom plate, and a middle plate that separates the drawers from the bookcase section.
-   Constructed from `melanine_thickness_main` material.
-   The corpus is divided into two compartments. The bottom compartment contains six drawers and the top compartment is a bookcase with two shelves.

### 3.2. Drawers

-   The drawers are made of `melanine_thickness_secondary` thick melanine and are mounted to the sides of the corpus with slides.
-   Each drawer has a front panel made of `melanine_thickness_main` thick melanine.
-   Dowel holes are included in the side and bottom panels for joining with the front panels.
-   The drawer assembly has been fixed, and the back panel of the drawer is now correctly positioned.

### 3.3. Drawer Fronts

-   The drawer fronts are separate from the drawer boxes and are made from `melanine_thickness_main` material.
-   Dowel holes are included for joining with the drawer boxes.
-   The design includes a consistent vertical `front_gap` between each front.
-   Handle holes have been added to drawer fronts.

### 3.4. Shelves

-   The bookcase has two shelves made of `melanine_thickness_main` thick melanine.

### 3.5. Slides

-   Represents the drawer slides that mount to the corpus sides.
-   These are modeled as simple blocks to correctly space the drawer boxes within the corpus.

### 3.6. HDF Back Panel

-   A 3mm HDF back panel is attached to the back of the corpus.

### 3.7. Pedestal

-   A 30mm high pedestal is placed under the corpus.

### 3.8. Glass Doors

-   The bookcase section is enclosed by two glass doors.

## 4. Joinery

-   **Corpus and Shelves:** Confirmat screws (4.8mm x 49mm) are used to join the corpus panels and shelves. 4mm pilot holes for these screws are included in the model.
-   **Drawers:** The drawer components are also joined with these screws, with the number of screws depending on the panel length (2 for <50cm, 3 for >=50cm) and placed 5cm from the edge. 4mm pilot holes for confirmat screws to join the drawer components have been added.
-   **Wooden Dowels:** Wooden dowels (phi 6 mm x 30 mm) are used to join the front panels to the drawer boxes. The front's blind hole is 1cm deep. There are two dowels per panel per side if the panel length is less than 50cm, and four dowels if longer, with even spacing. The hole locations are 5cm from the edge.
-   **Slide Pilot Holes:** Pilot holes for mounting the drawer slides are included in both the drawer sides and the corpus sides. These holes are 2mm deep and 2.5mm in diameter.
    -   **In Drawer Sides:** Two holes per slide, located 35mm and 163mm from the front edge.
    -   **In Corpus Sides:** Six holes per slide, located 6.5mm, 35mm, 51mm, 76, 99mm, and 115mm from the front edge.

## 5. Code Structure & Modularity

The `model.scad` file is structured for clarity and ease of use.

### 5.1. Component Modules

Each individual part (e.g., `corpus_side`, `drawer_bottom`) is defined in its own module. These are then assembled into more complex components (e.g., a full `drawer` or the `corpus`).

### 5.2. Drawing Modules & Debugging Flags

To aid in debugging and visualization, the final assembly is handled by a set of `draw_*` modules:

-   `draw_corpus()`
-   `draw_drawers()`
-   `draw_slides()`
-   `draw_fronts()`
-   `draw_shelves()`
-   `draw_glass_doors()`
-   `draw_hdf_back_panel()`
-   `draw_pedestal()`

The visibility of each of these component groups is controlled by a set of boolean flags at the top of the file (e.g., `show_corpus`). This allows a user to selectively render parts of the model to inspect specific areas without visual clutter.

## 6. Debugging and Verification

To assist with verifying the parametric design, key calculated dimensions are printed to the OpenSCAD console using the `echo()` function. This includes values like the position of the middle plate, the spacing of the shelves, and the dimensions of the drawers and doors. This allows for quick verification of the model's dimensions without needing to manually measure the 3D view.

## 7. Exploded View

The model includes an exploded view feature to help visualize how the components are assembled. This feature can be enabled by setting the `exploded_view` variable to `true`. The `explosion_factor` variable controls the distance between the exploded parts. The exploded view is now more sophisticated, with individual explosion for different component groups.

## 8. Cut List Generation

The `model.scad` file includes a feature to generate a CSV (Comma-Separated Values) cut list for all the panels required to build the furniture. This cut list includes panel dimensions, materials, quantities, edge banding requirements, and CNC comments.

To generate the cut list, set the `generate_cut_list_csv` variable to `true` at the top of the `model.scad` file. When the model is rendered, the cut list data will be printed to the OpenSCAD console. This data can then be saved to a CSV file.

For a more automated process, the `generate-csv.ps1` PowerShell script is provided. This script runs OpenSCAD, captures the console output, and saves the cleaned CSV data to `artifacts/cut_list.csv`.

## 9. CNC Export Workflow

The project includes a workflow for exporting the 2D panel drawings in DXF format, suitable for CNC cutting services.

The workflow consists of two main steps:
1.  **Exporting Panels from OpenSCAD:** The `export-panels.ps1` PowerShell script automates the export of all panels to the `artifacts/export` directory. The script gets the list of panels from the `model.scad` file and then calls OpenSCAD for each panel to generate a DXF file. All exported panels are positioned at the origin (0,0) to ensure consistency.
2.  **Layering DXF Files:** The `run-split-layers.ps1` script executes the `split-layers-dxf.ps1` script, which processes the exported DXF files using the `split_layers.py` Python script to separate the geometry into `CUT`, `DRILL`, and `DIMENSION` layers. This is necessary because OpenSCAD exports all geometry to a single layer. The script uses the `ezdxf` library to perform this operation.

This workflow ensures that the final DXF files are ready for use with CAM software, with clean separation between cutting paths and drill holes.

## 10. DXF Analysis

To verify that the DXF files have been correctly layered, the `analyze_dxf.py` script is provided. This script takes a directory as input and analyzes all the DXF files in that directory, printing a summary of the layers and the number of entities on each layer.

## 11. Hole Metadata Export

To facilitate the creation of manufacturing documentation, the model can now export detailed metadata for all holes on a given panel. This metadata includes the hole's name, its 2D projected coordinates (x, y), its Z coordinate (relative to the panel's thickness), its diameter, and its depth.

This is achieved through a series of new functions and modules:

- **`get_*_hole_2d_coords()` functions:** These functions are responsible for calculating the 2D projected coordinates of a hole based on the panel's export transformation.
- **`*_hole_metadata()` modules:** Each panel type with holes has a corresponding module that uses the coordinate transformation functions to `echo` the hole metadata to the OpenSCAD console during export. The Z coordinate is now correctly represented, with a value of `0` for holes drilled perpendicularly into the panel face and a value of half the panel's thickness for holes drilled into the edge.
- **`echo_hole_metadata()` module:** This top-level module is called during the export process and, based on the `export_panel_name` variable, it calls the appropriate `*_hole_metadata()` module to generate the metadata for the specified panel.

The `export-panels.ps1` script has been updated to capture this metadata from the console output and save it to a CSV file named after the panel (e.g., `CorpusSideLeft.csv`) in the `artifacts/export/dxf` directory.

The `split_layers.py` script has also been updated to read these CSV files and add text annotations to the DXF files on a new `ANNOTATION` layer. This includes a detailed "Hole Schedule" table with the hole name, diameter, depth, and its X, Y, and Z coordinates. This provides a fully automated workflow for generating richly annotated DXF files ready for manufacturing.

## 12. Changelog

### v5

*   **Enhanced Hole Visualization in DXF Export:**
    *   The `split_layers.py` script now includes the Z-coordinate in the text annotations for side-drilled holes (holes where the Z-coordinate is non-zero), providing clearer manufacturing information.
    *   A small cross symbol is now added at the (X,Y) location of side-drilled holes on the `DRILL` layer in 2D panel projections, serving as a visual indicator to distinguish them from through-holes or face-drilled holes.

### v4

*   Added a `DIMENSION` layer to the DXF export for panel and hole dimensions.
*   The dimensioning logic is optimized to avoid overlapping lines and redundant information.
*   Dimension text is now placed above the dimension line with a background fill for better readability.

### v3

*   Corrected the 2D hole coordinate calculation for DXF export to fix issues with reflected coordinates.
*   All exported 2D panels are now translated to start at the (0,0) origin.
*   The `split_layers.py` script now adds a detailed "Hole Schedule" table to the `ANNOTATION` layer of the DXF files.
*   The Z-coordinate in the hole metadata now correctly distinguishes between perpendicular and edge-drilled holes.

### v2

*   The number of drawers is now configurable.
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
*   Standardized all panel names to single-word strings (e.g., `CorpusSideLeft`) for consistency and easier use in scripts.
*   Updated the cut list to include CNC comments.
*   Added a CNC export workflow using PowerShell and Python scripts to generate layered DXF files.
*   Fixed SVG export for panels with non-through holes by ensuring the holed face is on the `z=0` plane during projection.
*   Added a PowerShell script `split-layers-dxf.ps1` to automate the layering of DXF files.
*   Added a Python script `analyze_dxf.py` to analyze the layers in the generated DXF files.
*   Removed in-model text annotations for hole dimensions and locations to speed up DXF export.
*   The `split_layers.py` script now adds annotations to the DXF files based on the hole metadata exported from OpenSCAD.
*   Added a hole metadata export feature to generate CSV files with hole locations, which are then used to create annotations in the DXF files.
