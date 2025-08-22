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
Entities on ANNOTATION layer: 4
Before saving - checking entities:
  Total entities in modelspace: 5
  Entity TEXT: layer='ANNOTATION', handle='32'
  Entity TEXT: layer='ANNOTATION', handle='33'
  Entity TEXT: layer='ANNOTATION', handle='34'
  Entity TEXT: layer='ANNOTATION', handle='35'
  Entity LWPOLYLINE: layer='CUT', handle='36'
After saving - entities found:
  Entity TEXT: layer='ANNOTATION', handle='32'
  Entity TEXT: layer='ANNOTATION', handle='33'
  Entity TEXT: layer='ANNOTATION', handle='34'
  Entity TEXT: layer='ANNOTATION', handle='35'
  Entity LWPOLYLINE: layer='CUT', handle='36'
  Entity TEXT: layer='ANNOTATION', handle='37'
  Entity TEXT: layer='ANNOTATION', handle='38'
  Entity TEXT: layer='ANNOTATION', handle='39'
  Entity TEXT: layer='ANNOTATION', handle='3A'
Verification: Saved file contains 9 entities
python.exe : Traceback (most recent call last):
At D:\dev\boris\OpenSCAD\chest-of-drawers-bookcase\split-layers-dxf.ps1:43 char:5
+     & $pythonPath $splitLayersScript $inputFile $outputFile
+     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (Traceback (most recent call last)::String) [], RemoteException
    + FullyQualifiedErrorId : NativeCommandError
 
  File "D:\dev\boris\OpenSCAD\chest-of-drawers-bookcase\split_layers.py", line 438, in <module>
    main()
    ~~~~^^
  File "D:\dev\boris\OpenSCAD\chest-of-drawers-bookcase\split_layers.py", line 435, in main
    split_layers(input_file, output_file)
    ~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^
  File "D:\dev\boris\OpenSCAD\chest-of-drawers-bookcase\split_layers.py", line 424, in split_layers
    print(f"\u2705 Layered DXF saved as {output_file}")
    ~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "C:\Python313\Lib\encodings\cp1252.py", line 19, in encode
    return codecs.charmap_encode(input,self.errors,encoding_table)[0]
           ~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
UnicodeEncodeError: 'charmap' codec can't encode character '\u2705' in position 0: character maps to <undefined>
FAILED
D:\dev\boris\OpenSCAD\chest-of-drawers-bookcase\split-layers-dxf.ps1 : Failed to process 'CorpusMiddle.dxf'.
At D:\dev\boris\OpenSCAD\chest-of-drawers-bookcase\run-split-layers.ps1:14 char:1
+ & (Join-Path $scriptDir "split-layers-dxf.ps1") 2>&1 | Tee-Object -Fi ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (:) [Write-Error], WriteErrorException
    + FullyQualifiedErrorId : Microsoft.PowerShell.Commands.WriteErrorException,split-layers-dxf.ps1
 
PS D:\dev\boris\OpenSCAD\chest-of-drawers-bookcase>