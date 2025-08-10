// Chest of Drawers with Integrated Bookcase
// The coordinate origin is at the lower left front of the corpus.
// The y-direction increases into the corpus body.
// This means that drawer fronts and glass doors will have y-origin in the negative direction.


// Debugging flags
show_corpus = true;
show_corpus_sides = false;
show_drawers = false;
show_fronts = true;
show_slides = true;
show_shelves = true;
show_glass_doors = true;
show_hdf_back_panel = false;

// Parameters

// Corpus
corpus_height = 2300;
corpus_width = 800;
corpus_depth = 230;

// Melanine material thickness
melanine_thickness_main = 19;
melanine_thickness_secondary = 12;

// HDF Back Panel
hdf_thickness = 3;

// Joinery
confirmat_screw_length = 49;
confirmat_hole_diameter = 4;
confirmat_hole_radius = confirmat_hole_diameter / 2;
confirmat_hole_edge_distance = 50;

// Dowels
dowel_diameter = 6;
dowel_radius = dowel_diameter / 2;
dowel_length = 30;
dowel_hole_depth_in_front = 10;
dowel_hole_edge_distance = 50;
panel_length_for_four_dowels = 500;

// Shelves
shelf_width = corpus_width - 2*melanine_thickness_main;
shelf_depth = corpus_depth;

// Slides
slide_width = 200;
slide_height = 45;
slide_depth = 13;
slide_z_offset = 50;

// Drawers
number_of_drawers = 6;
drawer_height = 200;
drawer_body_height = drawer_height - melanine_thickness_secondary;
drawer_depth = corpus_depth - 5;
drawer_width = shelf_width - 2*slide_depth;
drawer_body_width = drawer_width - 2*melanine_thickness_secondary;
drawer_bottom_offset = 10;     // the lowest drawer offset from the corpus bottom
drawer_gap = 10;    // the gap between drawers
drawer_vertical_space = drawer_height + drawer_gap;    // vertical space between drawers
drawer_origin_z = melanine_thickness_main + drawer_bottom_offset;     // offset of the bottom of the first drawer

// Middle Plate
middle_plate_z = drawer_origin_z + number_of_drawers*drawer_vertical_space;

// Drawer Fronts
front_gap = 3;
front_overhang = 3;
front_margin = 1.5; // margin on left and right side of drawer front
front_width = corpus_width - 2 * front_margin;
front_depth = melanine_thickness_main;
front_height_base = drawer_height + drawer_gap - front_gap;
front_height_first = melanine_thickness_main + drawer_bottom_offset - front_gap + front_height_base;
front_height_standard = front_height_base;
front_height_top = front_height_standard + 3*front_overhang;

// Bookcase dimensions
bookcase_start_z = middle_plate_z + melanine_thickness_main;
bookcase_end_z = corpus_height - melanine_thickness_main;
bookcase_height = bookcase_end_z - bookcase_start_z;
bookcase_shelf_gap = (bookcase_height - 2 * melanine_thickness_main) / 3;

// Bookcase glass doors
bookcase_glass_door_width = (corpus_width - (1 + front_gap + 1))/2;
bookcase_glass_door_height = melanine_thickness_main + bookcase_shelf_gap + melanine_thickness_main + bookcase_shelf_gap + melanine_thickness_main/2;
bookcase_glass_door_tickness = 4;

// Derived Measurements & Debugging
echo(str("Middle Plate Z: ", middle_plate_z));
echo(str("Bookcase Vertical Space: ", bookcase_height));
echo(str("Bookcase Shelf Gap: ", bookcase_shelf_gap));
echo(str("Bookcase Door Width: ", bookcase_glass_door_width));
echo(str("Bookcase Door Height: ", bookcase_glass_door_height));
echo(str("Drawer Vertical Space: ", drawer_vertical_space));
echo(str("Drawer Width: ", drawer_width));
echo(str("Shelf Width: ", shelf_width));
echo(str("First Drawer Front Height: ", front_height_first));
echo(str("Standard Drawer Front Height: ", front_height_standard));
echo(str("Top Drawer Front Height: ", front_height_top));

// Colors
color_corpus = "Red";
color_drawers = "Green";
color_drawer_back = "LightGreen";
color_fronts = "Blue";
color_shelves = "Yellow";
color_slides = "Gray";
color_joinery = "Black";
color_glass = "LightBlue";
color_hdf_panel = "White";

module confirmat_hole_side() {
    cylinder(h=melanine_thickness_main, r=confirmat_hole_radius, $fn=16, center=true);
}

module confirmat_hole_plate() {
    cylinder(h=confirmat_screw_length-melanine_thickness_main, r=confirmat_hole_radius, $fn=16);
}

module dowel_hole(height) {
    cylinder(h=height, r=dowel_radius, $fn=16);
}

module drawer_confirmat_hole() {
    cylinder(h=melanine_thickness_secondary, r=confirmat_hole_radius, $fn=16, center=true);
}

module drawer_confirmat_hole_threaded() {
    cylinder(h=confirmat_screw_length-melanine_thickness_secondary, r=confirmat_hole_radius, $fn=16);
}

module corpus_side(name="side") {
    difference() {
        color(color_corpus)
        cube([melanine_thickness_main, corpus_depth, corpus_height]);

        // Holes for bottom plate
        translate([melanine_thickness_main / 2, confirmat_hole_edge_distance, melanine_thickness_main / 2]) rotate([0, 90, 0]) confirmat_hole_side();
        translate([melanine_thickness_main / 2, corpus_depth - confirmat_hole_edge_distance, melanine_thickness_main / 2]) rotate([0, 90, 0]) confirmat_hole_side();

        // Holes for top plate
        translate([melanine_thickness_main / 2, confirmat_hole_edge_distance, corpus_height - melanine_thickness_main / 2]) rotate([0, 90, 0]) confirmat_hole_side();
        translate([melanine_thickness_main / 2, corpus_depth - confirmat_hole_edge_distance, corpus_height - melanine_thickness_main / 2]) rotate([0, 90, 0]) confirmat_hole_side();

        // Holes for middle plate
        translate([melanine_thickness_main / 2, confirmat_hole_edge_distance, middle_plate_z + melanine_thickness_main / 2]) rotate([0, 90, 0]) confirmat_hole_side();
        translate([melanine_thickness_main / 2, corpus_depth - confirmat_hole_edge_distance, middle_plate_z + melanine_thickness_main / 2]) rotate([0, 90, 0]) confirmat_hole_side();

        // Holes for shelves
        for (i = [0:1]) {
            z = middle_plate_z + (i + 1) * (melanine_thickness_main + bookcase_shelf_gap) + melanine_thickness_main / 2;
            translate([melanine_thickness_main / 2, confirmat_hole_edge_distance, z]) rotate([0, 90, 0]) confirmat_hole_side();
            translate([melanine_thickness_main / 2, corpus_depth - confirmat_hole_edge_distance, z]) rotate([0, 90, 0]) confirmat_hole_side();
        }
    }
}

module corpus_plate(width) {
    difference() {
        color(color_corpus)
        cube([width, corpus_depth, melanine_thickness_main]);

        // Holes for left side
        translate([0, confirmat_hole_edge_distance, melanine_thickness_main / 2]) rotate([0, 90, 0]) confirmat_hole_plate();
        translate([0, corpus_depth - confirmat_hole_edge_distance, melanine_thickness_main / 2]) rotate([0, 90, 0]) confirmat_hole_plate();

        // Holes for right side
        translate([width, confirmat_hole_edge_distance, melanine_thickness_main / 2]) rotate([0, -90, 0]) confirmat_hole_plate();
        translate([width, corpus_depth - confirmat_hole_edge_distance, melanine_thickness_main / 2]) rotate([0, -90, 0]) confirmat_hole_plate();
    }
}

module corpus() {
    if (show_corpus_sides) {
        // Left side
        translate([0, 0, 0])
        corpus_side();

        // Right side
        translate([corpus_width - melanine_thickness_main, 0, 0])
        corpus_side();
    }

    // Bottom plate
    translate([melanine_thickness_main, 0, 0])
    corpus_plate(corpus_width - 2*melanine_thickness_main);

    // Top plate
    translate([melanine_thickness_main, 0, corpus_height - melanine_thickness_main])
    corpus_plate(corpus_width - 2*melanine_thickness_main);

    // Middle plate
    translate([melanine_thickness_main, 0, middle_plate_z])
    corpus_plate(corpus_width - 2*melanine_thickness_main);
}

module drawer_side() {
    difference() {
        color(color_drawers)
        cube([melanine_thickness_secondary, drawer_depth, drawer_height]);

        // Holes for back panel (2 holes)
        translate([melanine_thickness_secondary/2, drawer_depth - melanine_thickness_secondary/2, confirmat_hole_edge_distance]) rotate([0, 90, 0]) drawer_confirmat_hole();
        translate([melanine_thickness_secondary/2, drawer_depth - melanine_thickness_secondary/2, drawer_height - confirmat_hole_edge_distance]) rotate([0, 90, 0]) drawer_confirmat_hole();

        // Holes for bottom panel (2 holes)
        translate([melanine_thickness_secondary/2, confirmat_hole_edge_distance, melanine_thickness_secondary/2]) rotate([0, 90, 0]) drawer_confirmat_hole();
        translate([melanine_thickness_secondary/2, drawer_depth - melanine_thickness_secondary - confirmat_hole_edge_distance, melanine_thickness_secondary/2]) rotate([0, 90, 0]) drawer_confirmat_hole();

        // Dowel holes for front panel
        translate([melanine_thickness_secondary/2, 0, dowel_hole_edge_distance]) rotate([90, 0, 0]) dowel_hole(dowel_length - dowel_hole_depth_in_front);
        translate([melanine_thickness_secondary/2, 0, drawer_height - dowel_hole_edge_distance]) rotate([90, 0, 0]) dowel_hole(dowel_length - dowel_hole_depth_in_front);
    }
}

module drawer_back() {
    difference() {
        color(color_drawer_back)
        cube([drawer_body_width, melanine_thickness_secondary, drawer_height]);

        // Holes for left side (2 holes)
        translate([0, melanine_thickness_secondary/2, confirmat_hole_edge_distance]) rotate([0, 90, 0]) drawer_confirmat_hole_threaded();
        translate([0, melanine_thickness_secondary/2, drawer_height - confirmat_hole_edge_distance]) rotate([0, 90, 0]) drawer_confirmat_hole_threaded();

        // Holes for right side (2 holes)
        translate([drawer_body_width, melanine_thickness_secondary/2, confirmat_hole_edge_distance]) rotate([0, -90, 0]) drawer_confirmat_hole_threaded();
        translate([drawer_body_width, melanine_thickness_secondary/2, drawer_height - confirmat_hole_edge_distance]) rotate([0, -90, 0]) drawer_confirmat_hole_threaded();

        // Holes for bottom panel (3 holes)
        translate([confirmat_hole_edge_distance, melanine_thickness_secondary/2, melanine_thickness_secondary/2]) rotate([90, 0, 0]) drawer_confirmat_hole();
        translate([drawer_body_width/2, melanine_thickness_secondary/2, melanine_thickness_secondary/2]) rotate([90, 0, 0]) drawer_confirmat_hole();
        translate([drawer_body_width - confirmat_hole_edge_distance, melanine_thickness_secondary/2, melanine_thickness_secondary/2]) rotate([90, 0, 0]) drawer_confirmat_hole();
    }
}

module drawer_bottom() {
    difference() {
        color(color_drawers)
        cube([drawer_body_width, drawer_depth - melanine_thickness_secondary, melanine_thickness_secondary]);

        // Holes for left side (2 holes)
        translate([0, confirmat_hole_edge_distance, melanine_thickness_secondary/2]) rotate([0, 90, 0]) drawer_confirmat_hole_threaded();
        translate([0, drawer_depth - melanine_thickness_secondary - confirmat_hole_edge_distance, melanine_thickness_secondary/2]) rotate([0, 90, 0]) drawer_confirmat_hole_threaded();

        // Holes for right side (2 holes)
        translate([drawer_body_width, confirmat_hole_edge_distance, melanine_thickness_secondary/2]) rotate([0, -90, 0]) drawer_confirmat_hole_threaded();
        translate([drawer_body_width, drawer_depth - melanine_thickness_secondary - confirmat_hole_edge_distance, melanine_thickness_secondary/2]) rotate([0, -90, 0]) drawer_confirmat_hole_threaded();

        // Holes for back panel (3 holes)
        translate([confirmat_hole_edge_distance, drawer_depth - melanine_thickness_secondary, melanine_thickness_secondary/2]) rotate([90, 0, 0]) drawer_confirmat_hole_threaded();
        translate([drawer_body_width/2, drawer_depth - melanine_thickness_secondary, melanine_thickness_secondary/2]) rotate([90, 0, 0]) drawer_confirmat_hole_threaded();
        translate([drawer_body_width - confirmat_hole_edge_distance, drawer_depth - melanine_thickness_secondary, melanine_thickness_secondary/2]) rotate([90, 0, 0]) drawer_confirmat_hole_threaded();

        // Dowel holes for front panel
        translate([dowel_hole_edge_distance, 0, melanine_thickness_secondary/2]) rotate([90, 0, 0]) dowel_hole(dowel_length - dowel_hole_depth_in_front);
        translate([drawer_body_width - dowel_hole_edge_distance, 0, melanine_thickness_secondary/2]) rotate([90, 0, 0]) dowel_hole(dowel_length - dowel_hole_depth_in_front);
        if (drawer_body_width > panel_length_for_four_dowels) {
            x_offset = (drawer_body_width - 2 * dowel_hole_edge_distance) / 3;
            translate([dowel_hole_edge_distance + x_offset, 0, melanine_thickness_secondary/2]) rotate([90, 0, 0]) dowel_hole(dowel_length - dowel_hole_depth_in_front);
            translate([dowel_hole_edge_distance + 2 * x_offset, 0, melanine_thickness_secondary/2]) rotate([90, 0, 0]) dowel_hole(dowel_length - dowel_hole_depth_in_front);
        }
    }
}

module drawer() {
    // Bottom
    translate([melanine_thickness_secondary, 0, 0])
    drawer_bottom();

    // Left side
    translate([0, 0, 0])
    drawer_side();

    // Right side
    translate([melanine_thickness_secondary + drawer_body_width, 0, 0])
    drawer_side();

    // Back
    translate([melanine_thickness_secondary, drawer_depth - melanine_thickness_secondary, 0])
    drawer_back();
}

module drawer_front(height) {
    difference() {
        color(color_fronts)
        cube([front_width, melanine_thickness_main, height]);

        // Dowel holes for left drawer side panel
        translate([(front_width - drawer_body_width)/2, melanine_thickness_main, dowel_hole_edge_distance]) rotate([-90,0,0]) dowel_hole(dowel_hole_depth_in_front);
        translate([(front_width - drawer_body_width)/2, melanine_thickness_main, height - dowel_hole_edge_distance]) rotate([-90,0,0]) dowel_hole(dowel_hole_depth_in_front);

        // Dowel holes for right drawer side panel
        translate([front_width - (front_width - drawer_body_width)/2, melanine_thickness_main, dowel_hole_edge_distance]) rotate([-90,0,0]) dowel_hole(dowel_hole_depth_in_front);
        translate([front_width - (front_width - drawer_body_width)/2, melanine_thickness_main, height - dowel_hole_edge_distance]) rotate([-90,0,0]) dowel_hole(dowel_hole_depth_in_front);

        // Dowel holes for drawer bottom panel
        translate([(front_width - drawer_body_width)/2 + dowel_hole_edge_distance, melanine_thickness_main, melanine_thickness_secondary/2]) rotate([-90,0,0]) dowel_hole(dowel_hole_depth_in_front);
        translate([(front_width - drawer_body_width)/2 + drawer_body_width - dowel_hole_edge_distance, melanine_thickness_main, melanine_thickness_secondary/2]) rotate([-90,0,0]) dowel_hole(dowel_hole_depth_in_front);
        if(drawer_body_width > panel_length_for_four_dowels) {
             x_offset = (drawer_body_width - 2 * dowel_hole_edge_distance) / 3;
             translate([(front_width - drawer_body_width)/2 + dowel_hole_edge_distance + x_offset, melanine_thickness_main, melanine_thickness_secondary/2]) rotate([-90,0,0]) dowel_hole(dowel_hole_depth_in_front);
             translate([(front_width - drawer_body_width)/2 + dowel_hole_edge_distance + 2 * x_offset, melanine_thickness_main, melanine_thickness_secondary/2]) rotate([-90,0,0]) dowel_hole(dowel_hole_depth_in_front);
        }
    }
}

module slide() {
    color(color_slides)
    cube([slide_depth, slide_width, slide_height]);
}

module shelf() {
    difference() {
        color(color_shelves)
        cube([shelf_width, shelf_depth, melanine_thickness_main]);

        // Holes for left side
        translate([0, confirmat_hole_edge_distance, melanine_thickness_main / 2]) rotate([0, 90, 0]) confirmat_hole_plate();
        translate([0, shelf_depth - confirmat_hole_edge_distance, melanine_thickness_main / 2]) rotate([0, 90, 0]) confirmat_hole_plate();

        // Holes for right side
        translate([shelf_width, confirmat_hole_edge_distance, melanine_thickness_main / 2]) rotate([0, -90, 0]) confirmat_hole_plate();
        translate([shelf_width, shelf_depth - confirmat_hole_edge_distance, melanine_thickness_main / 2]) rotate([0, -90, 0]) confirmat_hole_plate();
    }
}

module glass_door() {
    color(color_glass, 0.5)
    cube([bookcase_glass_door_width, bookcase_glass_door_tickness, bookcase_glass_door_height]);
}

module hdf_back_panel() {
    color(color_hdf_panel)
    cube([corpus_width, hdf_thickness, corpus_height]);
}

module draw_corpus() {
    if (show_corpus) {
        corpus();
    }
}

module draw_drawers() {
    if (show_drawers) {
        for (i = [0:number_of_drawers-1]) {
            z = drawer_origin_z + i * drawer_vertical_space;
            // Drawer box
            translate([melanine_thickness_main + slide_depth, 0, z])
            drawer();
        }
    }
}

module draw_slides() {
    if (show_slides) {
        for (i = [0:number_of_drawers-1]) {
            z = drawer_origin_z + i * drawer_vertical_space;
            // Slides
            translate([melanine_thickness_main, 0, z + slide_z_offset])
            slide();
            translate([corpus_width - melanine_thickness_main - slide_depth, 0, z + slide_z_offset])
            slide();
        }
    }
}

module draw_fronts() {
    if (show_fronts) {
        for (i = [0:number_of_drawers-1]) {
            z = drawer_origin_z + i * drawer_vertical_space;
            // Drawer front
            if (i == 0) {
                translate([front_margin, -front_depth, 0])
                drawer_front(front_height_first);
            } else if (i == 5) {
                translate([front_margin, -front_depth, z - front_overhang])
                drawer_front(front_height_top);
            } else {
                translate([front_margin, -front_depth, z - front_overhang])
                drawer_front(front_height_standard);
            }
        }
    }
}

module draw_shelves() {
    if (show_shelves) {
        for (i = [0:1]) {
            z = middle_plate_z + (i + 1) * (melanine_thickness_main + bookcase_shelf_gap);
            translate([melanine_thickness_main, 0, z])
            shelf();
        }
    }
}

module draw_glass_doors() {
    if (show_glass_doors) {
        // Left door
        translate([1, -bookcase_glass_door_tickness, corpus_height - bookcase_glass_door_height])
        glass_door();

        // Right door
        translate([1 + bookcase_glass_door_width + front_gap, -bookcase_glass_door_tickness, corpus_height - bookcase_glass_door_height])
        glass_door();
    }
}

module draw_hdf_back_panel() {
    if (show_hdf_back_panel) {
        translate([0, corpus_depth, 0])
        hdf_back_panel();
    }
}

// Assembly
draw_corpus();
draw_drawers();
draw_slides();
draw_fronts();
draw_shelves();
draw_glass_doors();
draw_hdf_back_panel();
