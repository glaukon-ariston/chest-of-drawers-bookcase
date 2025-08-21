# Chest of Drawers Bookcase

This project is a parametric 3D model of a chest of drawers with an integrated bookcase, designed in OpenSCAD.

![Chest of Drawers Bookcase](artifacts/chest-of-drawers-bookcase-openscad.png)

## Overview

The model is a highly customizable piece of furniture that combines a six-drawer chest with a three-tier bookcase. The entire design is parametric, meaning its dimensions and features can be easily modified by changing variables in the source code. The model is designed with realistic construction details in mind.

## Key Features

*   **Parametric Design:** Easily change the height, width, depth, and material thicknesses by editing the variables at the top of the `model.scad` file.
*   **Configurable Number of Drawers:** The number of drawers can be easily configured by changing the `number_of_drawers` variable.
*   **Realistic Construction:** The model incorporates practical construction details, including a fixed and correctly positioned drawer assembly with handle holes, a 3mm HDF back panel, a 30mm high pedestal, glass doors for the bookcase, and the precise, flush alignment of internal components like drawers and slides. It also includes 4mm pilot holes for the confirmat screws used for assembling the corpus and for joining the drawer components. Pilot holes for mounting the drawer slides are included in both the drawer sides and the corpus sides. Wooden dowels (6mm x 30mm) are used to join the front panels to the drawer boxes, with precisely drilled holes (1cm deep in the front, 5cm from edges, and evenly spaced) to ensure proper alignment and a strong bond.
*   **Modular Structure:** The code is organized into logical, reusable modules for each component (e.g., corpus, drawers, shelves), making it clean and easy to understand.
*   **Debugging Friendly:**
    *   **Transparency:** The model includes transparency for better visualization of internal structures.
    *   **Component Toggles:** Use boolean flags (e.g., `show_corpus`, `show_drawers`) to selectively render different parts of the model, simplifying inspection and debugging.
    *   **Console Output:** Key calculated dimensions are automatically printed to the OpenSCAD console, allowing for quick verification of the model's geometry.
*   **Descriptive Naming:** All variables use clear, descriptive names (e.g., `corpus_height`, `drawer_gap`) to enhance code readability and maintainability.
*   **Exploded View:** A configurable exploded view allows for easy visualization of the assembly by separating the components. This feature can be enabled by setting the `exploded_view` variable to `true`.
*   **Cut List Generation:** The project includes a feature to automatically generate a CSV cut list for all panels, including dimensions, materials, edge banding requirements, and CNC comments.
*   **Standardized Panel Naming:** All panel names have been updated to be single-word strings (e.g., `CorpusSideLeft`) for improved clarity and easier integration with other tools or scripts.
*   **CNC Export Workflow:** The project includes a workflow for exporting 2D panel drawings in DXF format, suitable for CNC cutting services.
*   **DXF Annotations:** The DXF export can include annotations for hole dimensions and locations, making the files more informative. The annotation text offset is now a vector parameter, allowing for different offsets for each annotation.

## Usage

1.  Open the `model.scad` file in [OpenSCAD](https://openscad.org/).
2.  Modify the parameters in the "Parameters" section to customize the design.
3.  Use the boolean flags in the "Debugging flags" section to show or hide specific components.
4.  Check the OpenSCAD console to see the calculated dimensions of the components.

### Generating the Cut List

To generate the cut list, run the `generate-csv.ps1` PowerShell script. This will create the `artifacts/cut_list.csv` file.

```powershell
.\generate-csv.ps1
```

### CNC Export Workflow

The project includes a workflow for exporting the 2D panel drawings in DXF format, suitable for CNC cutting services.

1.  **Export Panels:** Run the `export-panels.ps1` PowerShell script to export all panels to the `artifacts/export` directory.
2.  **Layer DXF Files:** Use the `split-layers-dxf.ps1` PowerShell script to post-process the exported DXF files. This will separate the geometry into `CUT` and `DRILL` layers, which is required by most CAM software.

For a complete breakdown of the design decisions, parameters, and code structure, please see the detailed [Model Description](prompt/model-v2.md).
