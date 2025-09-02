# CommonFunctions.psm1
#
# A module of common functions for the Chest of Drawers Bookcase project.

function Test-ExportDirectory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ExportDir
    )

    if ($ExportDir -eq "export/default") {
        # Using throw is better in a function than exit, as it allows the caller to handle the terminating error.
        throw "You must specify an export directory with the -ExportDir parameter. The default 'export/default' is not a valid value."
    }
}


function Assert-DirectoryExists {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        Write-Information "Creating directory at '$Path'"
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}


function Get-RelativePath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Base,

        [Parameter(Mandatory = $true)]
        [string]$TargetPath
    )

    # Convert to absolute paths without requiring them to exist on disk
    $resolvedBase = [System.IO.Path]::GetFullPath($Base)
    $resolvedTarget = [System.IO.Path]::GetFullPath($TargetPath)

    # The base path URI must end with a directory separator for MakeRelativeUri to work correctly on directories.
    if (-not $resolvedBase.EndsWith('\') -and -not $resolvedBase.EndsWith('/')) {
        $resolvedBase += [System.IO.Path]::DirectorySeparatorChar
    }

    # Create Uri objects for the base and target paths.
    $baseUri = [System.Uri]$resolvedBase
    $targetUri = [System.Uri]$resolvedTarget

    # Create the relative path and decode any URL-encoded characters.
    $relativePathUri = $baseUri.MakeRelativeUri($targetUri)
    $relativePath = [System.Uri]::UnescapeDataString($relativePathUri.ToString())

    # Convert forward slashes to backslashes on Windows for consistency
    if ([System.Environment]::OSVersion.Platform -eq [System.PlatformID]::Win32NT) {
        $relativePath = $relativePath.Replace('/', '\')
    }

    return $relativePath
}


function Initialize-LogFile {
    param(
        [string]$logFile
    )

    # Create the log directory if it doesn't exist
    $logDir = Split-Path $logFile
    Assert-DirectoryExists -Path $logDir
    # Clear the log file
    if (Test-Path $logFile) {
        Clear-Content $logFile
    }
} 


function Get-PanelNames {
    param(
        [string]$openscadPath,
        [string]$modelFile,
        [string]$logFile
    )

    # Get panel names from model.scad
    Write-Information "Getting panel names from '$modelFile' ..."
    # "openscad" -o "artifacts\export\dummy.png" --imgsize="1,1" -D "generate_panel_names_list=true" model.scad
    & $openscadPath -o "artifacts/dummy.png" --imgsize="1,1" -D "generate_panel_names_list=true" "$modelFile" 2>&1 | Out-File -FilePath $logFile -Encoding utf8

    # Read the console log file and process it
    $output = Get-Content $logFile
    $panelNames = $output | Where-Object { $_.StartsWith("ECHO:") } | ForEach-Object { $_.Substring(6).Trim().Trim('"') }

    if ($panelNames.Count -eq 0) {
        Write-Error "Error: Could not get panel names from '$modelFile'."
        Write-Error "Please check the 'generate_panel_names_list' functionality in the OpenSCAD script."
        exit 1
    }
    return $panelNames
}


function Get-ModelIdentifier {
    param(
        [string]$openscadPath,
        [string]$modelFile,
        [string]$logFile
    )

    & $openscadPath -o "artifacts/dummy.png" --imgsize="1,1" -D "generate_model_identifier=true" "$modelFile" 2>&1 | Out-File -FilePath $logFile -Encoding utf8

    # Read the console log file and process it
    $output = Get-Content $logFile
    $modelIdentifier = $output | Where-Object { $_.StartsWith("ECHO:") } | ForEach-Object { $_.Substring(6).Trim().Trim('"') }

    if ($modelIdentifier.Count -eq 0) {
        Write-Error "Error: Could not get model identifier from '$modelFile'."
        Write-Error "Please check the 'generate_model_identifier' functionality in the OpenSCAD script."
        exit 1
    }
    Write-Information "Model identifier: $modelIdentifier"
    return $modelIdentifier
}


# Export the functions to make them available to scripts that import this module.
Export-ModuleMember -Function Test-ExportDirectory, Assert-DirectoryExists, Get-RelativePath, Get-ModelIdentifier, Get-PanelNames, Initialize-LogFile

