Sending OpenSCAD designs directly to a panel cutting service is not straightforward, because OpenSCAD is for 3D solid modeling while CNC panel cutting services usually want 2D vector drawings (DXF/DWG) with clear layers for cutting and drilling.

Preparing files for a CNC cutting service from an OpenSCAD model involves several steps, as I'll need to convert my OpenSCAD 3D model into a series of 2D drawings that the service can use. The key is to generate a separate 2D drawing for each panel, showing its dimensions and the location of any holes.

Panel cutting and hole drilling require:
- 2D outlines of each panel (top view of the flat shape to be cut).
- Separate layers for operations:
    - Cutting layer → the outer contour of each panel.
    - Drilling layer → circles representing holes, usually with center marks or circles of the exact drill diameter.
- Units and scaling: usually millimeters, confirm with the service.
- File format: DWG.

Export each panel separately, so the CNC service has a clean drawing per part.

## Final Checks Before Sending
- Verify scale (1 unit = 1 mm).
- Check no overlapping lines (CNC machines can misinterpret).
- Check hole diameters match drill bit sizes used by the service.
- Create a simple drawing legend (layer names, units, material thickness).

Exported DXF files should be already separated into CUT and DRILL layers, so I don’t need to shuffle them in CAD later.

## Preparing the Files for the Service

This is the most critical step. The cutting service needs clear, unambiguous instructions. Merely providing the DWG files is often not enough.
- File Naming: Name each file clearly. Use a descriptive name that corresponds to a part in your model, such as "CorpusSideLeft.dwg" or "DrawerFrontFirst.dwg".
- Dimensions: Add dimensions to your drawings. While a CNC machine can read the geometry, having dimensions on the drawing helps the operator double-check and ensures there are no misinterpretations.
- Holes and Features: Make sure the holes for dowels, screws, or drawer slides are clearly visible in the drawings. The cutting service will use the vector data for these holes to program their drilling machine. You might need to add a legend or notes to specify the diameter and depth of each hole type. For instance, you could note a hole as "∅ 5mm thru" or "∅ 10mm deep."
- Quantity: Create a manifest or a simple text file listing the parts you need cut and the quantity of each. For example:
    - Side_Panel_Left.dwg (Qty 1)
    - Side_Panel_Right.dwg (Qty 1)
    - Shelf_Large.dwg (Qty 4)
- Material and Finish: Include a separate note or a cover sheet specifying the material you want to use (e.g., "18mm Plywood") and any finishing requirements. This information isn't in the DWG but is crucial for the service.

In order to send the order to the panel cutting service I need to have two things:
- the cut list specifing material, panel dimensions, panel count, edge banding, panel name and description, and CNC hole drilling comments.
- a DWG file, one file for each panel type.


