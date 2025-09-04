feat: Add Iverpan order generation script

This commit introduces a new feature to generate an order document for the Iverpan cutting service directly from the project's cut list.

A new Python script, `create_order.py`, has been added to automate this process. The script takes a model identifier, an Excel template, and an output directory as input, and generates a date-stamped Excel order file.

The following files have been added:
- `create_order.py`: The main script for generating the Iverpan order.
- `prompt/iverpan.md`: The user prompt describing the Iverpan order generation task.
- `template/iverpan_tablica_za_narudzbu.xlsx`: The Excel template for the Iverpan order.

The documentation has been updated to reflect these changes:
- `README.md`: Added `create_order.py` to the file list and a new section for "Iverpan Order Generation". Also added `ezdxf` and `openpyxl` to the installation requirements.
- `GEMINI.md`: Added `create_order.py` to the file list and a new section for "Iverpan Order Generation". Also added a new coding guideline to avoid catching exceptions.
- `prompt/model-v2.md`: Added a new section for "Iverpan Order Generation".

Other changes include:
- `generate-csv.ps1`: The script has been updated to handle the CSV header and data separately.
- `export/H2300xW600xD230_Mm19_Ms12/cut_list.csv`: The cut list now includes a "cnc comments" column.
