feat(workflow): add DXF to PDF conversion script

Introduces a new PowerShell script `convert-dxf-to-pdf.ps1` to automate the conversion of DXF panel drawings to PDF format using LibreCAD.

The script is designed to be robust against the known issue of LibreCAD's `dxf2pdf` tool returning an incorrect exit code (1) even on success. To handle this, the script verifies the successful creation of the output PDF file instead of relying on the exit code.

This new script is part of the CNC export workflow, providing an easy way to generate PDF documents for manufacturing or review.

The project documentation (`README.md`, `GEMINI.md`) has been updated to reflect this new workflow.