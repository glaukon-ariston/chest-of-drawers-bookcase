feat: Enhance workflow and order generation

This commit introduces several improvements to the project's workflow and order generation process.

**Key Changes:**

*   **Order Generation:**
    *   The `create_order.py` script has been refactored to support multiple cutting services (Iverpan and Elgrad).
    *   The script now accepts `--service` and `--template` arguments for greater flexibility.
    *   The output directory for orders is now `order/export/{model_id}`.

*   **Workflow:**
    *   The `workflow.ps1` script has been updated to automate the entire process, including the generation of order files for both Iverpan and Elgrad.
    *   The PowerShell scripts have been improved to use a common `CommonFunctions.psm1` module and dynamic export directories.

*   **Configuration:**
    *   The `.gitignore` file has been updated to exclude the new `order/export` directory from version control.

*   **Documentation:**
    *   The `README.md`, `GEMINI.md`, and `prompt/model-v2.md` files have been updated to reflect the recent changes.

**File-specific Changes:**

*   **`create_order.py`**: Refactored to support multiple services and moved to a more generic order generation script.
*   **`workflow.ps1`**: Now orchestrates the entire workflow, including order generation.
*   **`export-all.ps1`**: Updated to use the new export directory structure.
*   **`generate-csv.ps1`**: Updated to use the new export directory structure.
*   **`run-split-layers.ps1`**: Updated to use the new export directory structure.
*   **`split-layers-dxf.ps1`**: Updated to use the new export directory structure.
*   **`model.scad`**: Minor changes to support the new workflow.
*   **`.gitignore`**: Added `order/export/` to the ignore list.
*   **`TODO.md`**: Updated with the latest changes.