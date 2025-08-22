# run-split-layers.ps1
#
# This script executes the split-layers-dxf.ps1 script and logs the output.

$scriptDir = $PSScriptRoot
$logFile = Join-Path $scriptDir "artifacts/split-layers-dxf.log"

# Clear the log file
if (Test-Path $logFile) {
    Clear-Content $logFile
}

# Execute the script and tee the output to the log file
& (Join-Path $scriptDir "split-layers-dxf.ps1") 2>&1 | Tee-Object -FilePath $logFile -Append
