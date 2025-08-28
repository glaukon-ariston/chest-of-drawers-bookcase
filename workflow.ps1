# workflow.ps1
#
# This script orchestrates the entire workflow for generating various outputs
# from the OpenSCAD model, including cut lists, DXF, STL, and SVG exports,
# and subsequent conversions to DWG and PDF formats.

.\generate-csv.ps1
.\export-all.ps1
.\run-split-layers.ps1
.\convert-dxf-to-dwg.ps1
.\convert-dxf-to-pdf.ps1
