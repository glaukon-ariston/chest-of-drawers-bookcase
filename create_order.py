import openpyxl
import csv
import argparse
import datetime
import os

"""
Creates an Iverpan order document from a CSV cut list.

This script reads a CSV file containing a cut list and populates an Excel template
with the data to create an order document for the Iverpan cutting service.

Example:
    python create_order.py --model-id "H2300xW600xD230_Mm19_Ms12" --template "template/iverpan_tablica_za_narudzbu.xlsx"
"""

# Set up argument parser
parser = argparse.ArgumentParser(description='Create an Iverpan order document from a CSV cut list.')
parser.add_argument('--model-id', required=True, help='Model identifier.')
parser.add_argument('--template', required=True, help='Path to the Excel template file.')
args = parser.parse_args()

ORDER_DIR = 'order'

MATERIAL = {
    'MEL-19': 'MEL-19',
    'MEL-12': 'MEL-12',
    'HDF-3': 'HDF-3',
}

EDGE_BANDING = {
    'MEL-19': 'EDGE-19',
    'MEL-12': 'EDGE-12',
}


# Construct file paths
csv_file = os.path.join('export', args.model_id, 'cut_list.csv')
date_str = datetime.datetime.now().strftime("%Y%m%d")
output_file = os.path.join(ORDER_DIR, f"{args.model_id}_{date_str}.xlsx")

# Load the Excel template
workbook = openpyxl.load_workbook(args.template)

# Select the 'Narudžba' worksheet
sheet = workbook['Narudžba']

# Verify header
header_row = sheet[12]
header_values = [cell.value for cell in header_row]
expected_headers = ['R.b', 'Šifra materijala', 'Deb.', '1.Mjera ', '2. Mjera ', 'Br.', None, None, 'R.P. kantiranje desno', ' R.P. kantiranje lijevo', 'Napomena ', 'Napomena ', 'Napomena ', 'Napomena ', 'Napomena ', None]

if header_values != expected_headers:
    print("Error: Excel template header does not match expected header.")
    print("Expected:", expected_headers)
    print("Found:", header_values)
    exit()

# Read data from CSV and populate the Excel sheet
with open(csv_file, 'r', newline='', encoding='utf-8') as csvfile:
    reader = csv.reader(csvfile)
    next(reader)  # Skip header row

    # Start writing from row 14
    row_num = 14
    for row in reader:
        material_code = row[0]
        thickness = row[1]
        dim_A = float(row[2])
        dim_B = float(row[3])
        count = int(row[4])
        edge_A1 = int(row[5])
        edge_A2 = int(row[6])
        edge_B1 = int(row[7])
        edge_B2 = int(row[8])
        panel_name = row[9]
        panel_desc = row[10]
        cnc_comments = row[11]

        sheet.cell(row=row_num, column=2).value = MATERIAL[material_code]
        sheet.cell(row=row_num, column=3).value = thickness
        sheet.cell(row=row_num, column=4).value = dim_A
        sheet.cell(row=row_num, column=5).value = dim_B
        sheet.cell(row=row_num, column=6).value = count
        sheet.cell(row=row_num, column=7).value = None if edge_A1 == 0 else EDGE_BANDING[material_code]
        sheet.cell(row=row_num, column=8).value = None if edge_A2 == 0 else EDGE_BANDING[material_code]
        sheet.cell(row=row_num, column=9).value = None if edge_B1 == 0 else EDGE_BANDING[material_code]
        sheet.cell(row=row_num, column=10).value = None if edge_B2 == 0 else EDGE_BANDING[material_code]
        
        sheet.cell(row=row_num, column=11).value = panel_name
        sheet.cell(row=row_num, column=12).value = panel_desc
        sheet.cell(row=row_num, column=13).value = cnc_comments

        row_num += 1

# Save the new Excel file
workbook.save(output_file)

print(f"Successfully created order file: {output_file}")
