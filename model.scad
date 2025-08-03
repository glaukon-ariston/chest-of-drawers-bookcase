// Debugging flags
show_corpus = true;
show_drawers = true;
show_fronts = true;
show_slides = true;
show_shelves = true;
show_glass_doors = true;

// Parameters

// Corpus
N = 6;      // number of drawers
H = 2300;
W = 800;
D = 230;

// Melanine material thickness
T1 = 19;
T2 = 12;

// Shelves
Pw = W - 2*T1;
Ph = D;

// Slides
Sw = 200;
Sh = 45;
Sd = 13;

// Drawers
Dh = 200;
DBh = Dh - T2;
Dd = D - 5;
Dw = Pw - 2*Sd;
DBw = Dw - 2*T2;
Doffset = 10;     // the lowest drawer offset from the corpus bottom
Doffset2 = 10;    // the gap between drawers
Dvspace = Dh + Doffset2;    // vertical space between drawers
Dorigin = T1 + Doffset;     // offset of the bottom of the first drawer

// Middle Plate
Mz = Dorigin + N*Dvspace;

// Drawer Fronts
Gap = 3;
Overhang = 3;
Fw = W;
Fh0 = Dh + Doffset2 - Gap;
F1h = T1 + Doffset - Gap + Fh0;
Fh = Fh0;
Ftoph = Fh + 3*Overhang;

// Bookcase dimensions
bookcase_start_z = Mz + T1;
bookcase_end_z = H - T1;
bookcase_h = bookcase_end_z - bookcase_start_z;
bookcase_shelf_gap = (bookcase_h - 2 * T1) / 3;

bookcase_glass_door_width = (W - (1 + Gap + 1))/2;
bookcase_glass_door_height = T1 + bookcase_shelf_gap + T1 + bookcase_shelf_gap + T1/2;

// Derived Measurements & Debugging
echo(str("Middle Plate Z: ", Mz));
echo(str("Bookcase Vertical Space: ", bookcase_h));
echo(str("Bookcase Shelf Gap: ", bookcase_shelf_gap));
echo(str("Bookcase Door Width: ", bookcase_glass_door_width));
echo(str("Bookcase Door Height: ", bookcase_glass_door_height));
echo(str("Drawer Vertical Space: ", Dvspace));
echo(str("Drawer Width: ", Dw));
echo(str("Shelf Width: ", Pw));
echo(str("First Drawer Front Height: ", F1h));
echo(str("Standard Drawer Front Height: ", Fh));
echo(str("Top Drawer Front Height: ", Ftoph));

// Colors
color_corpus = "Red";
color_drawers = "Green";
color_fronts = "Blue";
color_shelves = "Yellow";
color_slides = "Gray";
color_joinery = "Black";
color_glass = "LightBlue";

module confirmat_hole() {
    cylinder(h=T1, r=2.5, $fn=16);
}

module dowel_hole() {
    cylinder(h=10, r=3, $fn=16);
}

module corpus_side(name="side") {
    color(color_corpus)
    cube([T1, D, H]);
}

module corpus_plate(width) {
     color(color_corpus)
    cube([width, D, T1]);
}

module corpus() {
    // Left side
    translate([0, 0, 0])
    corpus_side();

    // Right side
    translate([W - T1, 0, 0])
    corpus_side();

    // Bottom plate
    translate([T1, 0, 0])
    corpus_plate(W - 2*T1);

    // Top plate
    translate([T1, 0, H - T1])
    corpus_plate(W - 2*T1);

    // Middle plate
    translate([T1, 0, Mz])
    corpus_plate(W - 2*T1);
}

module drawer_side() {
    color(color_drawers)
    cube([T2, Dd, Dh]);
}

module drawer_back() {
    color(color_drawers)
    cube([DBw, T2, DBh]);
}

module drawer_bottom() {
    color(color_drawers)
    cube([DBw, Dd, T2]);
}

module drawer() {
    // Bottom
    translate([T2, 0, 0])
    drawer_bottom();

    // Left side
    translate([0, 0, 0])
    drawer_side();

    // Right side
    translate([DBw + T2, 0, 0])
    drawer_side();

    // Back
    translate([T2, Dd - T2, T2])
    drawer_back();
}

module drawer_front(height) {
    color(color_fronts)
    cube([Fw, T1, height]);
}

module slide() {
    color(color_slides)
    cube([Sd, Sw, Sh]);
}

module shelf() {
    color(color_shelves)
    cube([Pw, Ph, T1]);
}

module glass_door() {
    color(color_glass, 0.5)
    cube([bookcase_glass_door_width, 4, bookcase_glass_door_height]);
}

module draw_corpus() {
    if (show_corpus) {
        corpus();
    }
}

module draw_drawers() {
    if (show_drawers) {
        for (i = [0:N-1]) {
            z = Dorigin + i * Dvspace;
            // Drawer box
            translate([T1 + Sd, (D - Dd) / 2, z])
            drawer();
        }
    }
}

module draw_slides() {
    if (show_slides) {
        for (i = [0:N-1]) {
            z = Dorigin + i * Dvspace;
            // Slides
            translate([T1, (D - Sw) / 2, z + (Dh - Sh) / 2])
            slide();
            translate([W - T1 - Sd, (D - Sw) / 2, z + (Dh - Sh) / 2])
            slide();
        }
    }
}

module draw_fronts() {
    if (show_fronts) {
        for (i = [0:N-1]) {
            z = Dorigin + i * Dvspace;
            // Drawer front
            if (i == 0) {
                translate([0, D, 0])
                drawer_front(F1h);
            } else if (i == 5) {
                translate([0, D, z - Overhang])
                drawer_front(Ftoph);
            } else {
                translate([0, D, z - Overhang])
                drawer_front(Fh);
            }
        }
    }
}

module draw_shelves() {
    if (show_shelves) {
        for (i = [0:1]) {
            z = Mz + (i + 1) * (T1 + bookcase_shelf_gap);
            translate([T1, 0, z])
            shelf();
        }
    }
}

module draw_glass_doors() {
    if (show_glass_doors) {
        // Left door
        translate([1, D, H - bookcase_glass_door_height])
        glass_door();

        // Right door
        translate([1 + bookcase_glass_door_width + Gap, D, H - bookcase_glass_door_height])
        glass_door();
    }
}

// Assembly
draw_corpus();
draw_drawers();
draw_slides();
draw_fronts();
draw_shelves();
draw_glass_doors();