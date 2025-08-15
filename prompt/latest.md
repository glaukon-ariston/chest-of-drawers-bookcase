Create a plan for generating a cut list for panels that the chest of drawers needs. Consider that front edges need edge banding applied. Also some internal edges for the premium finish. Do not generate any code yet. Consider the OpenSCAD script generating the CSV file if that's possible.

Corpus vertical side panels have edge banding applied to the top and bottom of the panel as well as the front edge.

Drawer panels need edge banding on all exposed edges. E.g. bottom panel does not need edge banding, back panel needs top end bottom edge banding and side panels need edge banding on all edges except for the one facing the drawer front.

The output should be a CSV file with the following columns:
- material code
- material thickness
- dimension A (along wood grain)
- dimension B
- count
- edge banding A-1
- edge banding A-2
- edge banding B-1
- edge banding B-2
- panel name
- panel description
