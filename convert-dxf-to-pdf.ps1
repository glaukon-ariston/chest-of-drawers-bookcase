# convert-dxf-to-pdf.ps1
#
# This script converts DXF files to PDF format using LibreCAD.
# It expects the DXF files to be in a specific input directory and outputs
# the converted PDF files to a designated output directory.
# https://docs.librecad.org/en/latest/guides/console-tool.html#dxf2pdf-tool

# DXF to PDF Conversion
$scriptDir = $PSScriptRoot
$librecadPath = "D:\Program Files\LibreCAD\librecad.exe"
$dxfInputFiles = Join-Path $scriptDir "artifacts\export\dxf\*.dxf"
$pdfOutputDir = Join-Path $scriptDir "artifacts\export\pdf"

# --- Batch Convert Layered DXF to PDF using LibreCAD ---
if (-not (Test-Path $pdfOutputDir)) {
    Write-Output "Creating PDF output directory at '$pdfOutputDir'"
    New-Item -ItemType Directory -Path $pdfOutputDir | Out-Null
}

Write-Output "Starting batch conversion of DXF to PDF..."
# librecad.exe dxf2pdf --version --fit --paper 297x210 --margins 10,10,10,10 --pages 1x1 --directory artifacts/export/pdf artifacts/export/dxf/DrawerSideLeft.dxf
Write-Output "LibreCAD path: $librecadPath"
Write-Output "DXF input files: $dxfInputFiles"
Write-Output "PDF output directory: $pdfOutputDir"
& $librecadPath dxf2pdf --fit --paper 297x210 --margins 10,10,10,10 --pages 1x1 --directory "$pdfOutputDir" "$dxfInputFiles"

Write-Output "Batch DXF to PDF conversion completed with exit code $LASTEXITCODE."
Write-Output "Please check the output directory for the converted PDF files."
