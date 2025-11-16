# workflow.ps1
#
# This script orchestrates the entire workflow for generating various outputs
# from the OpenSCAD model, including cut lists, DXF, STL, and SVG exports,
# and subsequent conversions to DWG and PDF formats.

# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Import common functions
$scriptDir = $PSScriptRoot
Import-Module (Join-Path $scriptDir "ps-modules/CommonFunctions.psm1") -Force

# Project paths
$modelFile = Join-Path $scriptDir "model.scad"
# Please set the path to your OpenSCAD executable here.
$openscadPath = "openscad"
$consoleLogPath = "artifacts\openscad-console.log"
$pythonPath = "python"

# Generate model image to be included in README.md
# openscad -o "artifacts/model.png" --imgsize=600,1024 -D generate_cut_list_csv=false -D  export_panel_name='\"\"' -D generate_model_identifier=false -D generate_panel_names_list=false model.scad
Write-Output "Generating model image..."
& $openscadPath -o "artifacts/model.png" --imgsize=600,1024 -D generate_cut_list_csv=false -D  export_panel_name='\"\"' -D generate_model_identifier=false -D generate_panel_names_list=false $modelFile
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to generate model image. openscad exited with $LASTEXITCODE status."
    exit 1
}

$modelIdentifier = Get-ModelIdentifier -openscadPath $openscadPath -modelFile $modelFile -logFile $consoleLogPath
$exportDir = Join-Path $scriptDir "export/$modelIdentifier"

# Generate the cut list
.\generate-csv.ps1 -exportDir $exportDir

# Generate cuting services order files
& $pythonPath create_order.py --model-id "$modelIdentifier" --service iverpan --template "order/template/iverpan_tablica_za_narudzbu.xlsx" 2>&1
& $pythonPath create_order.py --model-id "$modelIdentifier" --service elgrad --template "order/template/elgrad_tablica_za_narudzbu.xlsx" 2>&1
& $pythonPath create_order.py --model-id "$modelIdentifier" --service sizekupres --template "order/template/sizekupres_tablica_za_narudzbu.xlsx" 2>&1
# TODO manually run furnir order generator to avoid runtime error
# & $pythonPath create_order.py --model-id "$modelIdentifier" --service furnir --template "order/template/furnir_tablica_za_narudzbu.xlsx" 2>&1

# Generate DXF, DWG and PDF exports
.\export-all.ps1 -exportDir $exportDir
.\run-split-layers.ps1 -exportDir $exportDir
.\convert-dxf-to-dwg.ps1 -exportDir $exportDir
.\convert-dxf-to-pdf.ps1 -exportDir $exportDir -dxfDir dxf-template -pdfDir pdf-template
.\convert-dxf-to-pdf.ps1 -exportDir $exportDir -dxfDir dxf -pdfDir pdf
