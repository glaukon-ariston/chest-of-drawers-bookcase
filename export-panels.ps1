# export-panels.ps1
#
# This script automates the export of all panels from the model.scad file
# to the export/$modelIdentifier directory for a specified export type (DXF, STL, or SVG).
# It iterates through a list of panel names obtained from the OpenSCAD model,
# and for each panel, it executes OpenSCAD to generate the corresponding
# output file. For DXF exports, it also attempts to extract hole metadata
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
    [ValidateSet("dxf", "stl", "svg")]
    [string]$exportType = "dxf",
    [string]$exportDir = "export/default"
)

# Exit immediately if a command exits with a non-zero status.
$ErrorActionPreference = "Stop"

# Import common functions
$scriptDir = $PSScriptRoot
Import-Module (Join-Path $scriptDir "ps-modules/CommonFunctions.psm1")

# Validate parameters
Test-ExportDirectory -ExportDir $exportDir

# --- Configuration ---

# Set-PSDebug -Trace 1

# Project paths
$modelFile = Join-Path $scriptDir "model.scad"
# Please set the path to your OpenSCAD executable here.
$openscadPath = "openscad"
$logFile = Join-Path $exportDir "log/openscad-console.log"
 
# --- Script ---

Initialize-LogFile -logFile $logFile

# Check if OpenSCAD executable exists
#if (-not (Test-Path $openscadPath)) {
#    Write-Output "Error: OpenSCAD executable not found at '$openscadPath'."
#    Write-Output "Please update the `$openscadPath variable in this script."
#    exit 1
#}

if ($exportType -eq "dxf") {
    $exportTypeDir = Join-Path $exportDir "dxf-raw"
} else {
    $exportTypeDir = Join-Path $exportDir $exportType
}

# Create export directory if it doesn't exist
Assert-DirectoryExists -Path $exportTypeDir

$panelNames = Get-PanelNames -openscadPath $openscadPath -modelFile $modelFile -logFile $logFile
Write-Output "Found $($panelNames.Count) panels to export."
Write-Output "Panel names found: $($panelNames -join ', ')"

# Loop through panel names and export DXF|STL files
foreach ($panelName in $panelNames) {
    $safePanelName = $panelName -replace '[\\/:"*?<>|]', '_' # Sanitize file name
    $outputFile = Join-Path $exportTypeDir "$safePanelName.$exportType"

    # Make the output path relative for cleaner logging
    $relativeOutputFile = Get-RelativePath -Base $exportDir -TargetPath $outputFile
    Write-Output "Exporting '$panelName' to '$relativeOutputFile' ... "
    
    # Execute OpenSCAD and capture any output (including errors from stderr)
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
}

Write-Output "All panels exported successfully to '$exportTypeDir'"

# Set-PSDebug -Trace 0
