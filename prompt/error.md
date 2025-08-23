PS D:\dev\boris\OpenSCAD\chest-of-drawers-bookcase> .\run-split-layers.ps1
Found 17 DXF files to process.
Processing 'CorpusMiddle.dxf' ... Converting from DXF version AC1009 to R2000 for LWPOLYLINE support
Found annotation file: D:\dev\boris\OpenSCAD\chest-of-drawers-bookcase\artifacts\export\dxf\CorpusMiddle.csv
  - Added annotation: d4.0 h30.0 at (0.0, 50.0)
  - Added annotation: d4.0 h30.0 at (0.0, 180.0)
  - Added annotation: d4.0 h30.0 at (762.0, 50.0)
  - Added annotation: d4.0 h30.0 at (762.0, 180.0)
Processing file: D:\dev\boris\OpenSCAD\chest-of-drawers-bookcase\artifacts\export\dxf\CorpusMiddle.dxf
 - Found entity: LWPOLYLINE
 - Created LWPOLYLINE on CUT layer
Created 1 entities
Entities on CUT layer: 1
Entities on DRILL layer: 0
Entities on ANNOTATION layer: 36
Before saving - checking entities:
  Total entities in modelspace: 37
  Entity TEXT: layer='ANNOTATION', handle='33'
  Entity TEXT: layer='ANNOTATION', handle='34'
  Entity TEXT: layer='ANNOTATION', handle='35'
  Entity TEXT: layer='ANNOTATION', handle='36'
  Entity LWPOLYLINE: layer='CUT', handle='37'
  Entity TEXT: layer='ANNOTATION', handle='38'
  Entity TEXT: layer='ANNOTATION', handle='39'
  Entity TEXT: layer='ANNOTATION', handle='3A'
  Entity TEXT: layer='ANNOTATION', handle='3B'
  Entity TEXT: layer='ANNOTATION', handle='3C'
  Entity TEXT: layer='ANNOTATION', handle='3D'
  Entity TEXT: layer='ANNOTATION', handle='3E'
  Entity LINE: layer='ANNOTATION', handle='3F'
  Entity TEXT: layer='ANNOTATION', handle='40'
  Entity TEXT: layer='ANNOTATION', handle='41'
  Entity TEXT: layer='ANNOTATION', handle='42'
  Entity TEXT: layer='ANNOTATION', handle='43'
  Entity TEXT: layer='ANNOTATION', handle='44'
  Entity TEXT: layer='ANNOTATION', handle='45'
  Entity TEXT: layer='ANNOTATION', handle='46'
  Entity TEXT: layer='ANNOTATION', handle='47'
  Entity TEXT: layer='ANNOTATION', handle='48'
  Entity TEXT: layer='ANNOTATION', handle='49'
  Entity TEXT: layer='ANNOTATION', handle='4A'
  Entity TEXT: layer='ANNOTATION', handle='4B'
  Entity TEXT: layer='ANNOTATION', handle='4C'
  Entity TEXT: layer='ANNOTATION', handle='4D'
  Entity TEXT: layer='ANNOTATION', handle='4E'
  Entity TEXT: layer='ANNOTATION', handle='4F'
  Entity TEXT: layer='ANNOTATION', handle='50'
  Entity TEXT: layer='ANNOTATION', handle='51'
  Entity TEXT: layer='ANNOTATION', handle='52'
  Entity TEXT: layer='ANNOTATION', handle='53'
  Entity TEXT: layer='ANNOTATION', handle='54'
  Entity TEXT: layer='ANNOTATION', handle='55'
  Entity TEXT: layer='ANNOTATION', handle='56'
  Entity TEXT: layer='ANNOTATION', handle='57'
python.exe : Traceback (most recent call last):
At D:\dev\boris\OpenSCAD\chest-of-drawers-bookcase\split-layers-dxf.ps1:43 char:5
+     & $pythonPath $splitLayersScript $inputFile $outputFile
+     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (Traceback (most recent call last)::String) [], RemoteException
    + FullyQualifiedErrorId : NativeCommandError
 
  File "D:\dev\boris\OpenSCAD\chest-of-drawers-bookcase\split_layers.py", line 611, in <module>
    main()
    ~~~~^^
  File "D:\dev\boris\OpenSCAD\chest-of-drawers-bookcase\split_layers.py", line 608, in main
    split_layers(input_file, output_file)
    ~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\dev\boris\OpenSCAD\chest-of-drawers-bookcase\split_layers.py", line 560, in split_layers
    add_dimensions(msp, holes, (min_x, min_y, max_x, max_y), doc)
    ~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\dev\boris\OpenSCAD\chest-of-drawers-bookcase\split_layers.py", line 308, in add_dimensions
    if not doc.dimstyles.has_style("Standard"):
           ^^^^^^^^^^^^^^^^^^^^^^^
AttributeError: 'DimStyleTable' object has no attribute 'has_style'
FAILED
D:\dev\boris\OpenSCAD\chest-of-drawers-bookcase\split-layers-dxf.ps1 : Failed to process 'CorpusMiddle.dxf'.
At D:\dev\boris\OpenSCAD\chest-of-drawers-bookcase\run-split-layers.ps1:14 char:1
+ & (Join-Path $scriptDir "split-layers-dxf.ps1") 2>&1 | Tee-Object -Fi ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (:) [Write-Error], WriteErrorException
    + FullyQualifiedErrorId : Microsoft.PowerShell.Commands.WriteErrorException,split-layers-dxf.ps1
 
PS D:\dev\boris\OpenSCAD\chest-of-drawers-bookcase> 