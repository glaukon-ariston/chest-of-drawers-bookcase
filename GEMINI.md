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
    *   H = 230 cm
    *   W = 80 cm
    *   D = 23 cm
*   **Melanine material thickness:**
    *   T1 = 19 mm
    *   T2 = 12 mm
*   **Shelves:**
    *   Pw = W - 2*T1
    *   Ph = D
*   **Slides:**
    *   Sw = 200 mm
    *   Sh = 45 mm
    *   Sd = 13 mm
*   **Drawers:**
    *   Dh = 20 cm
    *   DBh = Dh - T2
    *   Dd = D - 0.5 cm
    *   Dw = Pw - 2*Sd
    *   DBw = Dw - 2*T2
    *   Doffset = 1 cm
    *   Doffset2 = 1 cm
*   **Drawer Fronts:**
    *   Gap = 3 mm
    *   Overhang = 3 mm
    *   Fw = W
    *   Fh0 = Dh + Doffset - Gap
    *   F1h = T1 + Fh0
    *   Fh = Overhang + Fh0
    *   F6h = Fh + Overhang

### Structure

*   **Corpus:** The corpus is made of T1 thick melanine and consists of two sides, a top, a bottom and a middle plate. The corpus is divided into two compartments. The bottom compartment contains six drawers and the top compartment is a bookcase with two shelves.
*   **Drawers:** The drawers are made of T2 thick melanine and are mounted to the sides of the corpus with slides. Each drawer has a front panel made of T1 thick melanine.
*   **Shelves:** The bookcase has two shelves made of T1 thick melanine.
*   **Joinery:** Confirmat screws (phi 5 mm) are used to join the corpus and drawer panels. Wooden dowels (phi 6 mm x 30 mm) are used to join the front panels to the drawer boxes.

## Changelog

### v2

*   The drawer assembly has been fixed. The back panel of the drawer is now correctly positioned.
*   The model has been made more parametric.
*   The file `prompt/model-v2.md` has been added to reflect the changes in the model.

## Usage

To view the 3D model, open the `model.scad` file in [OpenSCAD](https://openscad.org/).
