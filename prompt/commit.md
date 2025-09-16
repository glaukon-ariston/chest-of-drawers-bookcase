feat(order): Add support for Furnir cutting service

Refactored the `create_order.py` script to support an additional cutting service, 'Furnir'.

The main changes include:

- **Generalized Material/Edge Banding:** The material and edge banding definitions have been restructured into a nested dictionary under the `MATERIAL` constant. This makes the code more modular and extensible for future services.

- **Added `process_furnir_order` function:** A new function dedicated to handling the specific format and requirements of the Furnir order template.

- **Updated Main Execution Block:** The main part of the script now includes logic to call the appropriate processing function based on the `--service` argument.

- **Configuration:** Added `.vscode` to `.gitignore` to exclude editor-specific files from the repository.

- **Documentation:** Updated `TODO.md` with more specific items.