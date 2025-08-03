Generate OpenSCAD code for a chest of drawers with integrated bookcase. Put the code in a file named model.scad.

These are the main dimensions from which all other dimensions are derived:

Corpus
H = 230 cm
W = 80 cm
D = 23 cm

Melanine material thickness
T1 = 19 mm
T2 = 12 mm

Shelves
Pw = W - 2*T1
Ph = D

Slides
Sw = 200 mm
Sh = 45 mm
Sd = 13 mm

Drawers
Dh = 20 cm
DBh = Dh - T2
Dd = D - 0.5 cm
Dw = Pw - 2*Sd
DBw = Dw - 2*T2
Doffset = 1 cm
Doffset2 = 1 cm

Drawer Fronts
Gap = 3 mm
Overhang = 3 mm
Fw = W
Fh0 = Dh + Doffset - Gap
F1h = T1 + Fh0
Fh = Fh0
F6h = Fh + Overhang


The material is T1 thick melanine for the corpus and bookshelves.

The drawer fronts are also T1 thick melanine.

The drawer corpus is made out of T2 melanine.

The whole is structured as follows:

Corpus
- The corpus consists of two sides and the top, the bottom and the middle plates.
- The corpus is H tall, W wide and D deep.
- The two sides are H tall and D wide and made out of T1 melanine.
- The top, bottom and three shelves are W-2*T1 tall and D wide.
- The middle plate divides the corpus into two compartments.
- The bottom compartment contains only drawers.
- The top compartment is split into three parts by two shelves.

Drawers
- Each drawer is mounted to the sides of the corpus by the way of slides.
- There are two slides per drawer, a left one and a right one.
- A slide is Sw wide, Sh tall and Sd deep.
- Looking from left to right there is the left side panel of thickness T1, then the left slide of thickness Sd, then the drawer Dw wide and Dh heigh, the right slide of thickness Sd and the right side panel of thickness T1. 
- There will be six drawers starting at the bottom.
- The lowest drawer starts at Doffset from the bottom plate of the corpus.
- The bottom of each subsequent drawer body is positioned Dh + Doffset2 above the bottom of the previous one (i.e., y_bottom_body[i+1] = y_bottom_body[i] + Dh + Doffset2).
- The middle plate sits Doffset2 higher than the top of the last drawer and forms a shelf.
- Each drawer consists of four plates:
- - The drawer's back plate is DBh tall and DBw wide.
- - The two side plates are Dh tall and Dd wide.
- - The drawer's bottom plate is Dd tall and DBw wide.
- - The drawer's sides are screwed to the drawer's bottom plate and to the back plate with comfirmat screws phi 5 mm.
- - The drawer's bottom plate sits between the two side plates.
- - The back plate sits on top of the bottom plate and is screwed to the side plates only (with confirmat screws phi 5 mm).

Drawer Fronts
- The design intends for a constant Gap between the visible fronts.
- The first drawer front is taller to account for the overlap T1 with the bottom plate of the corpus.
- The last drawer front is also taller to account for the smaller overlap with the middle plate of the corpus.
- Drawers two to six have Overhang below the bottom of the drawer.
- The first, lowest drawer front is Fw wide and F1h tall.
- The last, the sixth drawer front is Fw wide and F6h tall.
- The middle drawer fronts are Fw wide and Fh tall.

Shelves
- The top compartment is split into three parts by two shelves.
- Each shelf plate is Pw wide and Ph tall.

Joinery
Confirmat screws phi 5 mm are used to join corpus panels and drawer panels.
The front pannels are joined with wooden dowels (phi 6 mm by 30 mm length) to the drawer box (to the side panels and the bottom panel).
The dowels stick 1 cm deep into the drawer front and the rest is in the drawer box.
Make appropriate holes for dowels in drawer fronts, sides and bottom.
Make appropriate hole for confirmat screws in corpus sides, top, middle and bottom plates, and shelves too.
Make appropriate hole for confirmat screws in drawer sides, back plate and bottom plate.

Make every component as a OpenSCAD module, starting from the corpus down to the joinery.

Paint different types of components in a vivid and distinct color so that components can be easily distinguished one form another in the preview.

