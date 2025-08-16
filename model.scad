// Chest of Drawers with Integrated Bookcase
// The coordinate origin is at the lower left front of the corpus.
// The y-direction increases into the corpus body.
// This means that drawer fronts and glass doors will have y-origin in the negative direction.

// Trace string to console
show_trace = false;

// Cut List Generation
generate_cut_list_csv = true;

// Transparency
part_alpha = 0.4;

// Debugging flags
show_corpus = true;
show_corpus_sides = true;
show_drawers = true;
show_fronts = true;
show_slides = true;
show_shelves = true;
show_glass_doors = true;
show_hdf_back_panel = true;
show_pedestal = true;

// Exploded View Parameters
exploded_view = false; // Set to true to enable exploded view
explosion_factor = 2; // Scale factor for explosion distance

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

// Pedestal
pedestal_height = 30;


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

// Slide Pilot Holes
slide_pilot_hole_depth = 2;
slide_pilot_hole_diameter = 2.5;
slide_pilot_hole_radius = slide_pilot_hole_diameter / 2;
drawer_slide_pilot_hole_offsets = [35, 163];
corpus_slide_pilot_hole_offsets = [6.5, 35, 51, 76, 99, 115];

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
handle_hole_diameter = 4;
handle_hole_spacing = 160;

// Bookcase dimensions
bookcase_start_z = middle_plate_z + melanine_thickness_main;
bookcase_end_z = corpus_height - melanine_thickness_main;
bookcase_height = bookcase_end_z - bookcase_start_z;
bookcase_shelf_gap = (bookcase_height - 2 * melanine_thickness_main) / 3;

// Bookcase glass doors
bookcase_glass_door_width = (corpus_width - (1 + front_gap + 1))/2;
bookcase_glass_door_height = melanine_thickness_main + bookcase_shelf_gap + melanine_thickness_main + bookcase_shelf_gap + melanine_thickness_main/2;
bookcase_glass_door_tickness = 4;

// Trace string to console
module T(s) {
    if (show_trace) {
        echo(s);
    }
}

// Derived Measurements & Debugging
T(str("Middle Plate Z: ", middle_plate_z));
T(str("Bookcase Vertical Space: ", bookcase_height));
T(str("Bookcase Shelf Gap: ", bookcase_shelf_gap));
T(str("Bookcase Door Width: ", bookcase_glass_door_width));
T(str("Bookcase Door Height: ", bookcase_glass_door_height));
T(str("Drawer Vertical Space: ", drawer_vertical_space));
T(str("Drawer Width: ", drawer_width));
T(str("Shelf Width: ", shelf_width));
T(str("First Drawer Front Height: ", front_height_first));
T(str("Standard Drawer Front Height: ", front_height_standard));
T(str("Top Drawer Front Height: ", front_height_top));

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
color_pedestal = "SaddleBrown";

module explode(component_center) {
    if (exploded_view) {
        corpus_center = [corpus_width/2, corpus_depth/2, corpus_height/2];
        translate((component_center - corpus_center) * explosion_factor) children();
    } else {
        children();
    }
}

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

module handle_hole() {
    cylinder(h=melanine_thickness_main, r=handle_hole_diameter/2, $fn=16, center=true);
}

module slide_pilot_hole() {
    cylinder(h=slide_pilot_hole_depth, r=slide_pilot_hole_radius, $fn=16);
}

module corpus_side(is_left = true) {
    difference() {
        color(color_corpus, part_alpha)
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
        
        // Pilot holes for drawer slides
        for (i = [0:number_of_drawers-1]) {
            z = drawer_origin_z + i * drawer_vertical_space + slide_z_offset + slide_height / 2;
            for (offset = corpus_slide_pilot_hole_offsets) {
                if (is_left) {
                    translate([melanine_thickness_main, offset, z]) rotate([0, -90, 0]) slide_pilot_hole();
                } else {
                    translate([0, offset, z]) rotate([0, 90, 0]) slide_pilot_hole();
                }
            }
        }
    }
}

module corpus_plate(width) {
    difference() {
        color(color_corpus, part_alpha)
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
        corpus_side(is_left = true);

        // Right side
        translate([corpus_width - melanine_thickness_main, 0, 0])
        corpus_side(is_left = false);
    }

    // Bottom plate
    translate([melanine_thickness_main, 0, 0])
    corpus_plate(shelf_width);

    // Top plate
    translate([melanine_thickness_main, 0, corpus_height - melanine_thickness_main])
    corpus_plate(shelf_width);

    // Middle plate
    translate([melanine_thickness_main, 0, middle_plate_z])
    corpus_plate(shelf_width);
}

module drawer_side(is_left = true) {
    difference() {
        color(color_drawers, part_alpha)
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
        
        // Pilot holes for slides
        z_pos = slide_z_offset + slide_height/2;
        for (offset = drawer_slide_pilot_hole_offsets) {
            if (is_left) {
                translate([0, offset, z_pos]) rotate([0, 90, 0]) slide_pilot_hole();
            } else {
                translate([melanine_thickness_secondary, offset, z_pos]) rotate([0, -90, 0]) slide_pilot_hole();
            }
        }
    }
}

module drawer_back() {
    difference() {
        color(color_drawer_back, part_alpha)
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
        color(color_drawers, part_alpha)
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
    drawer_side(is_left = true);

    // Right side
    translate([melanine_thickness_secondary + drawer_body_width, 0, 0])
    drawer_side(is_left = false);

    // Back
    translate([melanine_thickness_secondary, drawer_depth - melanine_thickness_secondary, 0])
    drawer_back();
}

module drawer_front(height, handle_z) {
    difference() {
        color(color_fronts, part_alpha)
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
        
        // Handle holes
        translate([front_width/2 - handle_hole_spacing/2, melanine_thickness_main/2, handle_z]) rotate([90, 0, 0]) handle_hole();
        translate([front_width/2 + handle_hole_spacing/2, melanine_thickness_main/2, handle_z]) rotate([90, 0, 0]) handle_hole();
    }
}

module slide() {
    color(color_slides, part_alpha)
    cube([slide_depth, slide_width, slide_height]);
}

module shelf() {
    difference() {
        color(color_shelves, part_alpha)
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
    color(color_hdf_panel, part_alpha)
    cube([corpus_width, hdf_thickness, corpus_height]);
}

module pedestal() {
    // Front
    difference() {
        translate([melanine_thickness_main, 0, -pedestal_height])
        color(color_pedestal, part_alpha)
        cube([shelf_width, melanine_thickness_main, pedestal_height]);
        
        // Holes for left side
        translate([melanine_thickness_main, melanine_thickness_main/2, -pedestal_height/2])
        rotate([0, 90, 0])
        confirmat_hole_plate();
        
        // Holes for right side
        translate([corpus_width - melanine_thickness_main, melanine_thickness_main/2, -pedestal_height/2])
        rotate([0, -90, 0])
        confirmat_hole_plate();
    }

    // Back
    difference() {
        translate([melanine_thickness_main, corpus_depth - melanine_thickness_main, -pedestal_height])
        color(color_pedestal, part_alpha)
        cube([shelf_width, melanine_thickness_main, pedestal_height]);
        
        // Holes for left side
        translate([melanine_thickness_main, corpus_depth - melanine_thickness_main/2, -pedestal_height/2])
        rotate([0, 90, 0])
        confirmat_hole_plate();
        
        // Holes for right side
        translate([corpus_width - melanine_thickness_main, corpus_depth - melanine_thickness_main/2, -pedestal_height/2])
        rotate([0, -90, 0])
        confirmat_hole_plate();
    }

    // Left
    difference() {
        translate([0, 0, -pedestal_height])
        color(color_pedestal, part_alpha)
        cube([melanine_thickness_main, corpus_depth, pedestal_height]);
        
        // Hole for front panel
        translate([melanine_thickness_main/2, melanine_thickness_main/2, -pedestal_height/2])
        rotate([0, 90, 0])
        confirmat_hole_side();
        
        // Hole for back panel
        translate([melanine_thickness_main/2, corpus_depth - melanine_thickness_main/2, -pedestal_height/2])
        rotate([0, 90, 0])
        confirmat_hole_side();
    }

    // Right
    difference() {
        translate([corpus_width - melanine_thickness_main, 0, -pedestal_height])
        color(color_pedestal, part_alpha)
        cube([melanine_thickness_main, corpus_depth, pedestal_height]);
        
        // Hole for front panel
        translate([corpus_width - melanine_thickness_main/2, melanine_thickness_main/2, -pedestal_height/2])
        rotate([0, -90, 0])
        confirmat_hole_side();
        
        // Hole for back panel
        translate([corpus_width - melanine_thickness_main/2, corpus_depth - melanine_thickness_main/2, -pedestal_height/2])
        rotate([0, -90, 0])
        confirmat_hole_side();
    }
}

module draw_pedestal() {
    if (show_pedestal) {
        pedestal();
    }
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
                drawer_front(front_height_first, drawer_origin_z + drawer_height / 2);
            } else if (i == 5) {
                translate([front_margin, -front_depth, z - front_overhang])
                drawer_front(front_height_top, drawer_height / 2 + front_overhang);
            } else {
                translate([front_margin, -front_depth, z - front_overhang])
                drawer_front(front_height_standard, drawer_height / 2 + front_overhang);
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

module generate_cut_list() {
    echo("material code,material thickness,dimension A (along wood grain),dimension B,count,edge banding A-1,edge banding A-2,edge banding B-1,edge banding B-2,panel name,panel description,cnc comments");

    // Corpus
    echo(str("MEL-19,", melanine_thickness_main, ",", corpus_height, ",", corpus_depth, ",1,1,0,1,1,Corpus Side Left,Vertical side panel of the main body,Face 4mm confirmat screw holes"));
    echo(str("MEL-19,", melanine_thickness_main, ",", corpus_height, ",", corpus_depth, ",1,1,0,1,1,Corpus Side Right,Vertical side panel of the main body,Face 4mm confirmat screw holes"));
    echo(str("MEL-19,", melanine_thickness_main, ",", shelf_width, ",", shelf_depth, ",2,1,0,0,0,Corpus Top/Bottom,Horizontal top and bottom panels,Edge 4mm confirmat screw holes"));
    echo(str("MEL-19,", melanine_thickness_main, ",", shelf_width, ",", shelf_depth, ",1,1,0,0,0,Corpus Middle,Horizontal shelf separating drawers and bookcase,Edge 4mm confirmat screw holes"));

    // Drawers
    echo(str("MEL-12,", melanine_thickness_secondary, ",", drawer_height, ",", drawer_depth, ",12,1,1,0,1,Drawer Side,Vertical side panel of a drawer,Face 4mm confirmat screw holes + Edge 6mm dowel holes"));
    echo(str("MEL-12,", melanine_thickness_secondary, ",", drawer_body_width, ",", drawer_height, ",6,1,1,0,0,Drawer Back,Vertical back panel of a drawer,Face 4mm confirmat screw holes + Edge 4mm confirmat screw holes"));
    echo(str("MEL-12,", melanine_thickness_secondary, ",", drawer_body_width, ",", drawer_depth - melanine_thickness_secondary, ",6,0,0,0,0,Drawer Bottom,Bottom panel of a drawer,Edge 4mm confirmat screw holes + Edge 6mm dowel holes"));

    // Drawer Fronts
    echo(str("MEL-19,", melanine_thickness_main, ",", front_width, ",", front_height_first, ",1,1,1,1,1,Drawer Front (First),Front panel for the bottom drawer,Face 6mm dowel holes"));
    echo(str("MEL-19,", melanine_thickness_main, ",", front_width, ",", front_height_standard, ",4,1,1,1,1,Drawer Front (Standard),Front panel for the middle 4 drawers,Face 6mm dowel holes"));
    echo(str("MEL-19,", melanine_thickness_main, ",", front_width, ",", front_height_top, ",1,1,1,1,1,Drawer Front (Top),Front panel for the top drawer,Face 6mm dowel holes"));

    // Bookcase
    echo(str("MEL-19,", melanine_thickness_main, ",", shelf_width, ",", shelf_depth, ",2,1,0,0,0,Shelf,Shelf in the bookcase section,Edge 4mm confirmat screw holes"));

    // Pedestal
    echo(str("MEL-19,", melanine_thickness_main, ",", shelf_width, ",", pedestal_height, ",2,1,0,0,0,Pedestal Front/Back,Front and back panels of the pedestal,Edge 4mm confirmat screw holes"));
    echo(str("MEL-19,", melanine_thickness_main, ",", corpus_depth, ",", pedestal_height, ",2,1,0,1,1,Pedestal Side,Side panels of the pedestal,Face 4mm confirmat screw holes"));

    // Back Panel
    echo(str("HDF-3,", hdf_thickness, ",", corpus_height, ",", corpus_width, ",1,0,0,0,0,HDF Back Panel,The back panel of the entire unit,No holes"));
}


// Assembly
draw_corpus();

if (exploded_view) {
    explode([melanine_thickness_main + slide_depth + drawer_width / 2, drawer_depth / 2, drawer_origin_z + (number_of_drawers * drawer_vertical_space) / 2]) { draw_drawers(); }
    explode([corpus_width / 2, drawer_depth / 2, drawer_origin_z + (number_of_drawers * drawer_vertical_space) / 2]) { draw_slides(); }
    explode([front_margin + front_width / 2, -front_depth / 2, drawer_origin_z + (number_of_drawers * drawer_vertical_space) / 2]) { draw_fronts(); }
    explode([melanine_thickness_main + shelf_width / 2, shelf_depth / 2, bookcase_start_z + (bookcase_height - melanine_thickness_main) / 2]) { draw_shelves(); }
    explode([corpus_width / 2, -bookcase_glass_door_tickness / 2, corpus_height - bookcase_glass_door_height / 2]) { draw_glass_doors(); }
    explode([corpus_width / 2, corpus_depth + hdf_thickness / 2, corpus_height / 2]) { draw_hdf_back_panel(); }
    explode([corpus_width / 2, corpus_depth / 2, -pedestal_height / 2]) { draw_pedestal(); }
} else {
    draw_drawers();
    draw_slides();
    draw_fronts();
    draw_shelves();
    draw_glass_doors();
    draw_hdf_back_panel();
    draw_pedestal();
}

if (generate_cut_list_csv) {
    generate_cut_list();
}
