Use the cutting list in @export/H2300xW600xD230_Mm19_Ms12/cut_list.csv to create an order document for Iverpan cutting service. The first line in the CSV file is the header, the rest is data. 

The order template is the following Excel @template/iverpan_tablica_za_narudzbu.xlsx file. The newly created order document should be placed in the @order directory. The template file has the following structure:
- There are three worksheets: `Narudžba`, `Dekori` and `Primjer`.
- The worksheet `Dekori` contains sheet materials and edge bandings.
- The worksheet `Primjer` contains an example how to fill the `Narudžba` worksheet.
- The first worksheet `Narudžba` is where all the data should be placed and has the following structure:
    - The rows 12 and 13 are header rows with the following columns (from A to O column):
        - R.b
        - Šifra materijala
        - Deb.
        - 1. Mjera (Smjer goda)
        - 2. Mjera
        - Br. kom
        - 1. mjera (kantiranje desno)
        - 1. mjera (kantiranje lijevo)
        - 2. mjera (kantiranje desno)
        - 2. mjera (kantiranje lijevo)
        - Napomena
        - Napomena
        - Napomena
        - Napomena
        - Napomena
    - The column A (R.b) is readonly.
    - The data should be entered starting from the row 14.

Ask me if you have any questions. Also let me know if I forgot to mention something.