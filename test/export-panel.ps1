## export-panels.ps1
# This script exports a single panel from the model.scad file
# to the export/$modelIdentifier directory for a specified export type (DXF, STL, or SVG).
# It executes OpenSCAD to generate the corresponding output file.
# For DXF exports, it also attempts to extract hole metadata
# from OpenSCAD's console output and save it as a separate CSV file.
#
# Output file formats:
# - DXF: AutoCAD Drawing Exchange Format. Contains 2D geometry of panels,
#        including cut lines and drill holes. For DXF exports, a companion
#        CSV file is generated containing detailed metadata for each hole.
# - STL: Stereolithography (Standard Tessellation Language). Represents 3D
#        surfaces as a collection of triangular facets. Used for 3D printing
#        or viewing 3D models.
# - SVG: Scalable Vector Graphics. An XML-based vector image format for
#        two-dimensional graphics.

param(
    [Parameter(Mandatory = $false)]
    [string]$panelName = "PedestalSideTemplate",
    [string]$exportType = "dxf"
)

# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Import common functions
$rootDir = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
Import-Module (Join-Path $rootDir "ps-modules/CommonFunctions.psm1") -Force

# Project paths
$modelFile = Join-Path $rootDir "model.scad"

# $openscadPath = 'C:\Program Files\OpenSCAD\openscad.exe'
$openscadPath = 'openscad'
$logFile = (Join-Path $rootDir "artifacts\openscad-console.log")
$modelIdentifier = Get-ModelIdentifier -openscadPath $openscadPath -modelFile $modelFile -logFile $logFile
$exportDir = Join-Path $rootDir "export/$modelIdentifier"
Write-Output "Export dir: $exportDir"

if ($exportType -eq "dxf") {
    $exportTypeDir = Join-Path $exportDir "dxf-raw"
} else {
    $exportTypeDir = Join-Path $exportDir $exportType
}

$safePanelName = $panelName -replace '[\\/:"*?<>|]', '_' # Sanitize file name
$outputFile = Join-Path $exportTypeDir "$safePanelName.$exportType"

Write-Output "Exporting '$panelName' to '$outputFile' ... "


# Make the output path relative for cleaner logging
$relativeOutputFile = Get-RelativePath -Base $exportDir -TargetPath $outputFile
Write-Output "Exporting '$panelName' to '$relativeOutputFile' ... "

# Execute OpenSCAD and capture any output (including errors from stderr)
# The export will generate two files: DXF|STL|SVG file (whatever was selected) and a CSV file containing hole metadata.
#
# "openscad" -o "artifacts\export\dummy-cmd.dxf" -D "export_panel_name=\"CorpusSideRight\"" model.scad
# "openscad" -o "artifacts\export\dummy-ps.dxf" -D "export_panel_name=`"CorpusSideRight`"" model.scad
# This parameter passing scheme took whole day to figure out. PowerShell quoting behaviour sucks!
$export_panel_name = 'export_panel_name=\"' + $panelName + '\"'
$export_type = 'export_type=\"' + $exportType + '\"'
& $openscadPath -o "$outputFile" -D "$export_panel_name" -D "$export_type" "$modelFile" 2>&1 | Out-File -FilePath $logFile -Encoding utf8

# Check the exit code of the last command
if ($LASTEXITCODE -eq 0) {
    # --- Create Hole Metadata CSV ---
    $holeMetadata = Get-Content $logFile | Where-Object { $_.StartsWith('ECHO: "Hole,') } | ForEach-Object { $_.Substring(6).Trim('"') }
    if ($holeMetadata.Count -gt 0) {
        $csvFile = Join-Path $exportTypeDir "$safePanelName.csv"
        $csvContent = @("PanelName,HoleName,X,Y,Z,Diameter,Depth,Nx,Ny,Nz")
        $holeMetadata | ForEach-Object {
            $line = $_ -replace 'Hole,', ''
            $csvContent += $line
        }
        $relativeCsvFile = Get-RelativePath -Base $exportDir -TargetPath $csvFile
        $csvContent | Out-File -FilePath $csvFile -Encoding utf8
        Write-Output "  -> Created hole metadata file: $relativeCsvFile"
    }
} else {
    Write-Output "FAILED with exit code $LASTEXITCODE"
    Write-Error "OpenSCAD failed to export '$panelName'."
    # Read the console log file and process it
    $openscadOutput = Get-Content $logFile
    $openscadOutput | ForEach-Object { Write-Error $_ }
    # Stop the script on the first error
    exit 1 # I've uncommented this to stop the script on the first failure.
}
