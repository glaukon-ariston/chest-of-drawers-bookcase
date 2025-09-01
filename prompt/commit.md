feat: Parameterize model and enhance workflow

This commit introduces a major refactoring of the project to support model parameterization and a more robust and flexible workflow.

The main changes are:

- **Model Parameterization:** The `corpus_width` in `model.scad` has been changed from 800mm to 600mm, making the model more compact. A `model_identifier` has been introduced to uniquely identify each model configuration based on its dimensions.

- **Workflow Automation:** The `workflow.ps1` script has been enhanced to automate the entire export and conversion process. It now dynamically creates a unique export directory for each model configuration (e.g., `export/H2300xW600xD230_Mm19_Ms12`), allowing multiple model configurations to coexist without overwriting each other.

- **Script Refactoring:** All PowerShell scripts have been refactored to use a new `CommonFunctions.psm1` module, which contains shared functions for logging, directory management, and interacting with OpenSCAD. This improves code reuse and maintainability.

### File-specific changes:

- **`model.scad`**:
    - Changed `corpus_width` from 800 to 600.
    - Added `model_identifier` and `generate_model_identifier` for dynamic export paths.
    - Changed edge banding for corpus sides in `generate_cut_list`.
    - General code formatting (empty lines).

- **`workflow.ps1`**:
    - Now dynamically gets `model_identifier` from `model.scad`.
    - Creates dynamic export directory.
    - Passes `exportDir` to other scripts.

- **`export-panels.ps1`**:
    - Refactored to use `CommonFunctions.psm1`.
    - Added `exportDir` parameter.
    - Improved logging and error handling.

- **`generate-csv.ps1`**:
    - Refactored to use `CommonFunctions.psm1`.
    - Added `exportDir` parameter.
    - No longer generates a PNG image of the model.

- **`run-split-layers.ps1`**:
    - Added `exportDir` parameter.
    - Creates log file inside the `log` subdirectory of the `exportDir`.

- **`split-layers-dxf.ps1`**:
    - Added `exportDir` parameter.
    - Uses `exportDir` to define input and output directories.

- **`convert-dxf-to-dwg.ps1`**:
    - Added `exportDir` parameter.
    - Uses `exportDir` to define input and output directories.
    - Assumes `ODAFileConverter` is in the system's PATH.

- **`convert-dxf-to-pdf.ps1`**:
    - Added `exportDir` parameter.
    - Uses `exportDir` to define input and output directories.
    - Assumes `librecad` is in the system's PATH.

- **`export-all.ps1`**:
    - Refactored to use `CommonFunctions.psm1`.
    - Added `exportDir` parameter and passes it to `export-panels.ps1`.

- **`generate-csv.bat`**:
    - Uses `openscad` from the PATH, instead of a hardcoded path.

- **`GEMINI.md`**, **`README.md`**, **`prompt/model-v2.md`**:
    - Updated to reflect the `corpus_width` change and the new dynamic export directory structure.
    - Updated changelogs to v8.