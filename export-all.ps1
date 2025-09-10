# export-all.ps1
#
# This script automates the export of all panels from the model.scad file
# to the export/$modelIdentifier directory for all supported export types.
# It orchestrates the execution of several other scripts:
# - export-panels.ps1: Exports panels to various formats (STL, DXF, SVG).
# - convert-dxf-to-dwg.ps1: Converts DXF files to DWG format.
# - convert-dxf-to-pdf.ps1: Converts DXF files to PDF format.
# - generate-csv.ps1: Generates a CSV file with panel information.
# - split-layers-dxf.ps1: Splits DXF files into individual layers.
# - run-split-layers.ps1: Runs the DXF layer splitting process.

param(
    [Parameter(Mandatory = $false)]
    [string]$exportDir = "export/default"
)

# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Import common functions
$scriptDir = $PSScriptRoot
Import-Module (Join-Path $scriptDir "ps-modules/CommonFunctions.psm1")

# Project paths
$modelFile = Join-Path $scriptDir "model.scad"
# Please set the path to your OpenSCAD executable here.
$openscadPath = "openscad"
$logFile = Join-Path $scriptDir "artifacts/openscad-console.log"

if ($exportDir -eq "export/default") {
    $modelIdentifier = Get-ModelIdentifier -openscadPath $openscadPath -modelFile $modelFile -logFile $logFile
    $exportDir = Join-Path $scriptDir "export/$modelIdentifier"
}

Assert-DirectoryExists -Path $exportDir

Write-Output "Exporting all panels to STL, DXF and SVG to export/$modelIdentifier directory..."

# Export to STL
.\export-panels.ps1 -exportDir $exportDir -exportType stl

# Export to DXF
.\export-panels.ps1 -exportDir $exportDir -exportType dxf

# Export to SVG
.\export-panels.ps1 -exportDir $exportDir -exportType svg

Write-Output "All panels exported successfully to export/$modelIdentifier directory."
