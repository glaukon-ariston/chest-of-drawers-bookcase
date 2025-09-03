feat: Improve documentation and workflow

This commit introduces several improvements to the project's documentation and workflow.

- **README.md:**
  - Added an image of the model to the "Model Description" section for better visualization.
  - Expanded the "Files" section to include all relevant scripts, providing a more complete overview of the project structure.

- **GEMINI.md:**
  - Expanded the "Files" section to align with `README.md`.

- **prompt/model-v2.md:**
  - Added a changelog entry for v10 to track the recent updates.

- **workflow.ps1:**
  - The script now automatically generates `artifacts/model.png`, ensuring the documentation image is always up-to-date with the latest model version.

- **model.scad:**
  - The `export_panel_name` variable is now empty by default. This prevents the accidental export of a default panel and improves the user experience.

- **generate-csv.ps1:**
  - Minor code cleanup (removed a blank line).