# "C:\Program Files\OpenSCAD\openscad.exe" -o "artifacts/model.png" --imgsize=1920,1080 -D generate_cut_list_csv=true  model.scad
$openscadPath = 'C:\Program Files\OpenSCAD\openscad.exe'
$outputCsvPath = "artifacts\cut_list.csv"
$outputTempCsvPath = "artifacts\temp_cut_list.csv"
$outputImagePath = "artifacts\model.png"
$modelPath = "model.scad"

# Check if files exist
if (!(Test-Path $openscadPath)) {
    Write-Error "OpenSCAD not found at: $openscadPath"
    exit 1
}

if (!(Test-Path $modelPath)) {
    Write-Error "Model file not found: $modelPath"
    exit 1
}

# Create output directory
$artifactsDir = Split-Path $outputCsvPath -Parent
if (!(Test-Path $artifactsDir)) {
    New-Item -ItemType Directory -Path $artifactsDir -Force
}

# Execute OpenSCAD and save all output to temp file first
# $tempFile = [System.IO.Path]::GetTempFileName()
$tempFile = $outputTempCsvPath
try {
    & $openscadPath -o $outputImagePath --imgsize="1920,1080" -D generate_cut_list_csv=true $modelPath 2>&1 | Out-File -FilePath $tempFile -Encoding utf8
    
    # Read the temp file and process it
    $allLines = Get-Content $tempFile
    $csvData = $allLines | Where-Object { $_ -match '^ECHO: "' } | ForEach-Object { 
        $_ -replace '^ECHO: "', '' -replace '"$', '' 
    }
    
    if ($csvData.Count -gt 0) {
        Write-Host "Found $($csvData.Count) CSV lines"
        $header = "material code,material thickness,dimension A (along wood grain),dimension B,count,edge banding A-1,edge banding A-2,edge banding B-1,edge banding B-2,panel name,panel description"
        # Combine header and data, then convert to CSV format and save to file.
        ($header, $csvData) | ConvertFrom-Csv | Export-Csv -NoTypeInformation -Path $outputCsvPath
        Write-Host "Cut list saved to: $outputCsvPath ($($csvData.Count) lines)"
    }
    else {
        Write-Warning "No ECHO lines found in output"
        $allLines | Select-Object -First 10 | ForEach-Object { Write-Host "[$_]" }
    }
}
finally {
    # Remove-Item $tempFile -ErrorAction SilentlyContinue
}
