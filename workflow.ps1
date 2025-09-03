# workflow.ps1
#
# This script orchestrates the entire workflow for generating various outputs
# from the OpenSCAD model, including cut lists, DXF, STL, and SVG exports,
# and subsequent conversions to DWG and PDF formats.

# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Import common functions
$scriptDir = $PSScriptRoot
Import-Module (Join-Path $scriptDir "ps-modules/CommonFunctions.psm1")

# Project paths
$modelFile = Join-Path $scriptDir "model.scad"
# Please set the path to your OpenSCAD executable here.
$openscadPath = "openscad"
$consoleLogPath = "artifacts\openscad-console.log"

# Generate model image to be included in README.md
# openscad -o "artifacts/model.png" --imgsize=1080,1920 -D generate_cut_list_csv=false -D  export_panel_name='\"\"' -D generate_model_identifier=false -D generate_panel_names_list=false model.scad
& $openscadPath -o "artifacts/model.png" --imgsize=1080,1920 -D generate_cut_list_csv=false -D  export_panel_name='\"\"' -D generate_model_identifier=false -D generate_panel_names_list=false $modelPath

$modelIdentifier = Get-ModelIdentifier -openscadPath $openscadPath -modelFile $modelFile -logFile $consoleLogPath
$exportDir = Join-Path $scriptDir "export/$modelIdentifier"

.\generate-csv.ps1 -exportDir $exportDir
.\export-all.ps1 -exportDir $exportDir
.\run-split-layers.ps1 -exportDir $exportDir
.\convert-dxf-to-dwg.ps1 -exportDir $exportDir
.\convert-dxf-to-pdf.ps1 -exportDir $exportDir
