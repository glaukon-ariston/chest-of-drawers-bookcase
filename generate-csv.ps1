# "C:\Program Files\OpenSCAD\openscad.exe" -o "artifacts/model.png" --imgsize=1920,1080 -D generate_cut_list_csv=true  model.scad
# openscad -o "artifacts/dummy.png" --imgsize=1,1 -D generate_model_identifier=true  model.scad

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

# $openscadPath = 'C:\Program Files\OpenSCAD\openscad.exe'
$openscadPath = 'openscad'
$outputCsv = "cut_list.csv"
$modelPath = "model.scad"

# Check if files exist
#if (!(Test-Path $openscadPath)) {
#    Write-Error "OpenSCAD not found at: $openscadPath"
#    exit 1
#}

if (!(Test-Path $modelPath)) {
    Write-Error "Model file not found: $modelPath"
    exit 1
}

if ($exportDir -eq "export/default") {
    $logFile = "artifacts\openscad-console.log"
    $modelIdentifier = Get-ModelIdentifier -openscadPath $openscadPath -modelFile $modelFile -logFile $logFile
    $exportDir = Join-Path $scriptDir "export/$modelIdentifier"
}
Write-Output "Export directory: $exportDir"

# Create the export directory if it doesn't exist
Assert-DirectoryExists -Path $exportDir

$logFile = Join-Path $exportDir "log\openscad-console.log"
Initialize-LogFile -logFile $logFile

# Execute OpenSCAD and save all output to temp file first
# $tempFile = [System.IO.Path]::GetTempFileName()
$outputCsvPath = Join-Path $exportDir $outputCsv
try {
    & $openscadPath -o "artifacts/dummy.png" --imgsize="1,1" -D generate_cut_list_csv=true $modelPath 2>&1 | Out-File -FilePath $logFile -Encoding utf8
    
    # Read the temp file and process it
    $allLines = Get-Content $logFile
    $csvData = $allLines | Where-Object { $_ -match '^ECHO: "' } | ForEach-Object { 
        $_ -replace '^ECHO: "', '' -replace '"$', '' 
    }
    
    if ($csvData.Count -gt 0) {
        Write-Output "Found $($csvData.Count) CSV lines"
        # Split the lines into header and data. Assume the first line is the header.
        $header = $csvData | Select-Object -First 1
        $data = $csvData | Select-Object -Skip 1
        # Combine header and data, then convert to CSV format and save to file.
        ($header, $data) | ConvertFrom-Csv | Export-Csv -NoTypeInformation -Path $outputCsvPath
        Write-Output "Cut list saved to: $outputCsvPath ($($data.Count) lines)"
    }
    else {
        Write-Warning "No ECHO lines found in output"
        $allLines | Select-Object -First 10 | ForEach-Object { Write-Host "[$_]" }
    }
}
finally {
    # Remove-Item $logFile -ErrorAction SilentlyContinue
}
