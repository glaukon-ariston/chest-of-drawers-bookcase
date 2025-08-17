# export-all.ps1
#
# This script automates the export of all panels from the model.scad file
# to the artifacts/export directory for all supported export types.

Write-Host "Exporting all panels to STL, DXF and SVG..."

# Export to STL
.\export-panels.ps1 -exportType stl

# Export to DXF
.\export-panels.ps1 -exportType dxf

# Export to SVG
.\export-panels.ps1 -exportType svg

Write-Host "All panels exported successfully."
