Placing text annotation on the model and getting it into the 2D projection of the panel does not work. This is supposedly a known OpenSCAD limitation. The only way I have managed to make the text appear in the projection is to cut it out using difference(). Now that I think of it, it makes a complete sense. So now, the plan is to forgo placing text annotations on the model in OpenSCAD and instead modify the @split_layers.py script to generate text annotations at appropriate locations in a separate ANNOTATION layer in DXF files. These hole location coordinates will be passed down from OpenSCAD during panel DXF export. 

In @model.scad add code that will echo a table of hole metadata. The table will include panel name, hole name, x and y coordinates, hole diameter, depth. Make it conditional on export being in progress, i.e. `export_panel_name != ""`. You do not need to pass panel name around. The export is done one panel at a time so you can use the globally defined `export_panel_name` variable. Do all the 2D projection calculation in OpenSCAD during the export. 

In @export-panels.ps1 add code that will parse the OpenSCAD output containing the hole table and create a CSV file next to the DXF file. Be careful when parsing output from OpenSCAD, watch out for quotes. Example console line: ECHO: "Hole,CorpusSideLeft,slide_pilot_2_1,521.5,35,2.5,2"     

Modify @split_layers.py to read the associated CSV file and create a new annotation layer with appropriately placed hole annotations.

Make a detailed plan and ask me any clarifying questions before proceeding. Before commencing changes save the detailed plan to @artifacts/hole-metadata-plan.md.
