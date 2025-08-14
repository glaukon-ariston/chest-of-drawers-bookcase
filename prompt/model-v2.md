# Chest of Drawers Bookcase: Model Description

This document provides a detailed description of the OpenSCAD model for the chest of drawers with an integrated bookcase. It outlines the design decisions, parametric setup, and modular structure of the `model.scad` file.

## 1. Overview

The model is a piece of furniture combining a six-drawer chest of drawers with a bookcase on top. The design is fully parametric, meaning the entire model can be resized by changing a few key variables. The model is built in a modular way in OpenSCAD, allowing for easy customization and debugging.

## 2. Parametric Design

The model is driven by a set of global parameters defined at the beginning of the `model.scad` file. This allows for easy modification of the overall dimensions and material thicknesses. The variable names are chosen to be descriptive for better readability.

### Main Dimensions

-   **Corpus:** `corpus_height`, `corpus_width`, `corpus_depth`, `number_of_drawers`
-   **Material Thickness:** `melanine_thickness_main` (for corpus and fronts), `melanine_thickness_secondary` (for drawer boxes), `hdf_thickness` (for the back panel)
-   **Drawer & Fronts:** `drawer_height`, `drawer_bottom_offset`, `drawer_gap`, `front_gap`, `front_overhang`, `front_margin`, `handle_hole_diameter`, `handle_hole_spacing`
-   **Slides:** `slide_z_offset`
-   **Joinery:** `confirmat_screw_length`, `confirmat_hole_diameter`, `confirmat_hole_edge_distance`, `dowel_diameter`, `dowel_length`, `dowel_hole_depth_in_front`, `dowel_hole_edge_distance`, `panel_length_for_four_dowels`, `slide_pilot_hole_depth`, `slide_pilot_hole_diameter`, `slide_pilot_hole_radius`, `drawer_slide_pilot_hole_offsets`, `corpus_slide_pilot_hole_offsets`

All other dimensions for components like shelves, drawer parts, and front panels are derived from these base parameters.

## 3. Component Breakdown

The model is broken down into several distinct components, each with its own OpenSCAD module for easy identification and manipulation.

### 3.1. Corpus

-   The main body of the furniture.
-   Consists of two side panels, a top plate, a bottom plate, and a middle plate that separates the drawers from the bookcase section.
-   Constructed from `melanine_thickness_main` material.
-   The back is enclosed by a 3mm HDF panel.

### 3.2. Drawers

-   The chest contains a variable number of identical drawer boxes (`number_of_drawers`).
-   Each drawer box is constructed from `melanine_thickness_secondary` material and consists of a bottom plate, two side plates, and a back plate, joined together with confirmat screws. Dowel holes are included in the side and bottom panels for joining with the front panels.
-   The drawer construction is robust, with the back panel positioned behind the bottom plate for added strength.
-   The drawers are designed to be mounted on slides and are positioned flush with the front of the corpus for a clean, modern look.

### 3.3. Drawer Fronts

-   The drawer fronts are separate from the drawer boxes and are made from `melanine_thickness_main` material. Dowel holes are included for joining with the drawer boxes.
-   The design includes a consistent vertical `front_gap` between each front.
-   The top and bottom drawer fronts are sized differently to account for overlaps with the corpus middle and bottom plates, ensuring a visually clean appearance.
-   The drawer fronts are horizontally centered within the corpus, with a `front_margin` on both the left and right sides.

### 3.4. Shelves

-   The top bookcase section contains two adjustable shelves, creating three open sections.
-   The shelves are made from `melanine_thickness_main` material.

### 3.5. Slides

-   Represents the drawer slides that mount to the corpus sides.
-   These are modeled as simple blocks to correctly space the drawer boxes within the corpus.
-   They are positioned flush with the front of the corpus, and their vertical position is controlled by the `slide_z_offset` parameter.

### 3.6. Glass Doors

-   Two glass doors are positioned in front of the bookcase section.
-   They cover the top two shelf gaps, leaving the lowest one open.
-   The doors are modeled with a 4mm thickness and a semi-transparent light blue color to simulate glass.
-   They are positioned to be flush with the top of the corpus, with a 1mm offset from the outer sides and a 3mm `front_gap` between them.

## 4. Joinery

-   **Corpus and Shelves:** 5mm Confirmat screws are used for joining the main corpus panels and shelves. 4mm pilot holes for these screws are included in the model.
-   **Drawers:** The drawer elements (sides, base, and back panels) are joined using 4.8mm thick and 49mm long Confirmat screws. The model now includes 4mm pilot holes for these screws. The number of screws is determined by the length of the joined panel edge: two screws for edges less than 50cm, and three for longer edges. The holes are positioned 5cm from each edge.
-   **Wooden Dowels:** The drawer fronts are joined to the drawer boxes with 6mm (`dowel_diameter`) x 30mm (`dowel_length`) wooden dowels. The front's blind hole is 1cm (`dowel_hole_depth_in_front`) deep. There are two dowels per panel per side if the panel length is less than 50cm, and four dowels if longer. The hole locations are 5cm (`dowel_hole_edge_distance`) from the edge and are evenly spaced. The dowels will be glued.
-   **Slide Pilot Holes:** Pilot holes for mounting drawer slides are included in both the drawer sides and the corpus sides. These holes are 2mm deep and 2.5mm in diameter.
    -   **In Drawer Sides:** Two holes per slide, located 35mm and 163mm from the front edge of the drawer side.
    -   **In Corpus Sides:** Six holes per slide, located 6.5mm, 35mm, 51mm, 76mm, 99mm, and 115mm from the front edge of the corpus side.

## 5. Code Structure & Modularity

The `model.scad` file is structured for clarity and ease of use.

### 5.1. Component Modules

Each individual part (e.g., `corpus_side`, `drawer_bottom`, `glass_door`, `hdf_back_panel`) is defined in its own module. These are then assembled into more complex components (e.g., a full `drawer` or the `corpus`).

### 5.2. Drawing Modules & Debugging Flags

To aid in debugging and visualization, the final assembly is handled by a set of `draw_*` modules:

-   `draw_corpus()`
-   `draw_drawers()`
-   `draw_slides()`
-   `draw_fronts()`
-   `draw_shelves()`
-   `draw_glass_doors()`
-   `draw_hdf_back_panel()`

The visibility of each of these component groups is controlled by a set of boolean flags at the top of the file (e.g., `show_corpus`, `show_glass_doors`). This allows a user to selectively render parts of the model to inspect specific areas without visual clutter.

## 6. Debugging and Verification

To assist with verifying the parametric design, key calculated dimensions are printed to the OpenSCAD console using the `echo()` function. This includes values like the position of the middle plate, the spacing of the shelves, and the dimensions of the drawers and doors. This allows for quick verification of the model's dimensions without needing to manually measure the 3D view.

## 7. Exploded View

The model includes an exploded view feature to help visualize how the components are assembled. This feature can be enabled by setting the `exploded_view` variable to `true`. The `explosion_factor` variable controls the distance between the exploded parts.