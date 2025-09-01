# run-split-layers.ps1
#
# This script executes the split-layers-dxf.ps1 script and logs the output.

param(
    [Parameter(Mandatory = $true)]
    [string]$exportDir = "export/default"
)

if ($exportDir -eq "export/default") {
    Write-Error "You have to specify an export directory with the -exportDir parameter."
    exit 1    
}

$scriptDir = $PSScriptRoot
$exportDir = Join-Path $scriptDir $exportDir
$logFile = Join-Path $exportDir "log/split-layers-dxf.log"
# Create the log directory if it doesn't exist
$logDir = Split-Path $logFile
if (-not (Test-Path $logDir)) {
    Write-Output "Creating log directory at '$logDir'"
    New-Item -ItemType Directory -Path $logDir | Out-Null
}

# Clear the log file
if (Test-Path $logFile) {
    Clear-Content $logFile
}

# Execute the script and tee the output to the log file
& (Join-Path $scriptDir "split-layers-dxf.ps1") 2>&1 | Tee-Object -FilePath $logFile -Append
