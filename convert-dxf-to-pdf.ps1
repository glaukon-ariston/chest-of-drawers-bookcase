# convert-dxf-to-pdf.ps1
#
# This script converts DXF files to PDF format using LibreCAD.
# It expects the DXF files to be in a specific input directory and outputs
# the converted PDF files to a designated output directory.
# https://docs.librecad.org/en/latest/guides/console-tool.html#dxf2pdf-tool
#
# e.g.
# .\convert-dxf-to-pdf.ps1 -exportDir export\H2300xW600xD230_Mm19_Ms12

param(
    [Parameter(Mandatory = $true)]
    [string]$exportDir = "export/default"
)

# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Import common functions
$scriptDir = $PSScriptRoot
Import-Module (Join-Path $scriptDir "ps-modules/CommonFunctions.psm1")

# Validate parameters
Test-ExportDirectory -ExportDir $exportDir

# DXF to PDF Conversion
# $librecadPath = "D:\Program Files\LibreCAD\librecad.exe"
$librecadPath = "librecad"
$dxfInputDir = Join-Path $exportDir "dxf"
$pdfOutputDir = Join-Path $exportDir "pdf"

# --- Batch Convert Layered DXF to PDF using LibreCAD ---
Assert-DirectoryExists -Path $pdfOutputDir

Write-Output "Starting batch conversion of DXF to PDF..."
# librecad.exe dxf2pdf --fit --paper 297x210 --margins 10,10,10,10 --pages 1x1 --directory artifacts/export/pdf artifacts/export/dxf/DrawerSideLeft.dxf
# librecad.exe dxf2pdf --fit --paper 297x210 --margins 10,10,10,10 --pages 1x1 --directory artifacts/export/pdf artifacts/export/dxf/*.dxf
# librecad.exe dxf2pdf --fit --paper 297x210 --margins 10,10,10,10 --pages 1x1 --directory "C:\Users\Tata\dev\chest-of-drawers-bookcase\export\H2300xW600xD230_Mm19_Ms12\pdf" "C:\Users\Tata\dev\chest-of-drawers-bookcase\export\H2300xW600xD230_Mm19_Ms12\dxf\*.dxf"

$dxfFiles = Get-ChildItem -Path $dxfInputDir -Filter "*.dxf"
if ($dxfFiles.Count -eq 0) {
    Write-Warning "No DXF files found in '$dxfInputDir' to convert."
    exit 0
}

foreach ($dxfFile in $dxfFiles) {
    $dxfFilePath = $dxfFile.FullName
    $pdfFileName = [System.IO.Path]::ChangeExtension($dxfFile.Name, ".pdf")
    $pdfFilePath = Join-Path $pdfOutputDir $pdfFileName

    Write-Output "Converting '$($dxfFile.Name)' to PDF..."

    # We don't check the exit code because LibreCAD's dxf2pdf tool is known to return 1 on success.
    # Cannot check if the output file was created either because it gets created asynchronously.
    Write-Output "DXF input file: $dxfFilePath"
    Write-Output "PDF file: $pdfFilePath"
    & $librecadPath dxf2pdf --fit --paper 297x210 --margins 10,10,10,10 --pages 1x1 --outfile "$pdfFilePath" "$dxfFilePath"
}

Write-Output "All DXF files processed. Check the output directory for PDF files: $pdfOutputDir"