# Chest of Drawers Bookcase: Model Description

This document provides a detailed description of the OpenSCAD model for the chest of drawers with an integrated bookcase. It outlines the design decisions, parametric setup, and modular structure of the `model.scad` file.

## 1. Overview

The model is a piece of furniture combining a six-drawer chest of drawers with a bookcase on top. The design is fully parametric, meaning the entire model can be resized by changing a few key variables. The model is built in a modular way in OpenSCAD, allowing for easy customization and debugging.

## 2. Parametric Design

The model is driven by a set of global parameters defined at the beginning of the `model.scad` file. This allows for easy modification of the overall dimensions and material thicknesses. The variable names are chosen to be descriptive for better readability.

### Main Dimensions

-   **Corpus:** `corpus_height`, `corpus_width`, `corpus_depth`, `number_of_drawers`
-   **Material Thickness:** `melanine_thickness_main` (for corpus and fronts), `melanine_thickness_secondary` (for drawer boxes)
-   **Drawer & Fronts:** `drawer_height`, `drawer_bottom_offset`, `drawer_gap`, `front_gap`, `front_overhang`

All other dimensions for components like shelves, drawer parts, and front panels are derived from these base parameters.

## 3. Component Breakdown

The model is broken down into several distinct components, each with its own OpenSCAD module for easy identification and manipulation.

### 3.1. Corpus

-   The main body of the furniture.
-   Consists of two side panels, a top plate, a bottom plate, and a middle plate that separates the drawers from the bookcase section.
-   Constructed from `melanine_thickness_main` material.

### 3.2. Drawers

-   The chest contains a variable number of identical drawer boxes (`number_of_drawers`).
-   Each drawer box is constructed from `melanine_thickness_secondary` material and consists of a bottom plate, two side plates, and a back plate.
-   The drawers are designed to be mounted on slides.

### 3.3. Drawer Fronts

-   The drawer fronts are separate from the drawer boxes and are made from `melanine_thickness_main` material.
-   The design includes a consistent vertical `front_gap` between each front.
-   The top and bottom drawer fronts are sized differently to account for overlaps with the corpus middle and bottom plates, ensuring a visually clean appearance.

### 3.4. Shelves

-   The top bookcase section contains two adjustable shelves, creating three open sections.
-   The shelves are made from `melanine_thickness_main` material.

### 3.5. Slides

-   Represents the drawer slides that mount to the corpus sides.
-   These are modeled as simple blocks to correctly space the drawer boxes within the corpus.

### 3.6. Glass Doors

-   Two glass doors are positioned in front of the bookcase section.
-   They cover the top two shelf gaps, leaving the lowest one open.
-   The doors are modeled with a 4mm thickness and a semi-transparent light blue color to simulate glass.
-   They are positioned to be flush with the top of the corpus, with a 1mm offset from the outer sides and a 3mm `front_gap` between them.

## 4. Joinery

-   **Confirmat Screws:** The design specifies the use of 5mm Confirmat screws for joining the main corpus panels and for assembling the drawer boxes. Holes for these are intended but not fully modeled to keep the design clean.
-   **Wooden Dowels:** The drawer fronts are intended to be joined to the drawer boxes using 6mm wooden dowels.

## 5. Code Structure & Modularity

The `model.scad` file is structured for clarity and ease of use.

### 5.1. Component Modules

Each individual part (e.g., `corpus_side`, `drawer_bottom`, `glass_door`) is defined in its own module. These are then assembled into more complex components (e.g., a full `drawer` or the `corpus`).

### 5.2. Drawing Modules & Debugging Flags

To aid in debugging and visualization, the final assembly is handled by a set of `draw_*` modules:

-   `draw_corpus()`
-   `draw_drawers()`
-   `draw_slides()`
-   `draw_fronts()`
-   `draw_shelves()`
-   `draw_glass_doors()`

The visibility of each of these component groups is controlled by a set of boolean flags at the top of the file (e.g., `show_corpus`, `show_glass_doors`). This allows a user to selectively render parts of the model to inspect specific areas without visual clutter.

## 6. Debugging and Verification

To assist with verifying the parametric design, key calculated dimensions are printed to the OpenSCAD console using the `echo()` function. This includes values like the position of the middle plate, the spacing of the shelves, and the dimensions of the drawers and doors. This allows for quick verification of the model's dimensions without needing to manually measure the 3D view.
