// Chest of Drawers with Integrated Bookcase
// The coordinate origin is at the lower left front of the corpus.
// The y-direction increases into the corpus body.
// This means that drawer fronts and glass doors will have y-origin in the negative direction.

FN = 16;

// Trace string to console
show_trace = false;

// Cut List Generation
generate_model_identifier = false;
generate_cut_list_csv = false;
generate_panel_names_list = false;

// DXF Export: Set the panel name to export, e.g., "CorpusSideLeft"
// Panel selector (via -D name="...")
// See the 'export_panel' module for a list of all panel names.
export_panel_name = "DrawerBack";
export_type = "dxf";  // "dxf"|"stl"|"svg"

panel_names = ["CorpusSideLeft", "CorpusSideRight", "CorpusTopBottom", "CorpusMiddle", "DrawerSideLeft", "DrawerSideRight", "DrawerBack", "DrawerBottom", "DrawerFrontFirst", "DrawerFrontStandard", "DrawerFrontTop", "Shelf", "PedestalFrontBack", "PedestalSide", "HDFBackPanel"];

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
corpus_width = 600;
corpus_depth = 230;

// Melanine material thickness
melanine_thickness_main = 18;
melanine_thickness_secondary = 12;

model_identifier = str("H",corpus_height,"xW",corpus_width,"xD",corpus_depth,"_Mm",melanine_thickness_main,"_Ms",melanine_thickness_secondary);

// HDF Back Panel
hdf_thickness = 3;

// Pedestal
pedestal_height = 30;

// Geometric Constants
ROT_X_90 = [90, 0, 0];
ROT_X_NEG_90 = [-90, 0, 0];
ROT_Y_90 = [0, 90, 0];
ROT_Y_NEG_90 = [0, -90, 0];
ROT_Z_90 = [0, 0, 90];
ROT_Z_NEG_90 = [0, 0, -90];
ROT_NONE = [0, 0, 0];

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
color_annotation = "Magenta";

// The exported DXF will contain two layers: "CUT" for the panel outline and "DRILL" for the holes.
// Note: The dxf_layer module is a convention and might not be supported by all OpenSCAD versions or tools.

CUT = "red";
DRILL = "blue";


module dxf_layer(layer_name) {
    if (export_panel_name != "") {
        color(layer_name) children();
    } else {
        children();
    }
}

module explode(component_center) {
    if (exploded_view) {
        corpus_center = [corpus_width/2, corpus_depth/2, corpus_height/2];
        translate((component_center - corpus_center) * explosion_factor) children();
    } else {
        children();
    }
}

module confirmat_hole_side() {
    cylinder(h=melanine_thickness_main, r=confirmat_hole_radius, $fn=FN, center=true);
}

module confirmat_hole_plate() {
    cylinder(h=confirmat_screw_length-melanine_thickness_main, r=confirmat_hole_radius, $fn=FN);
}

module dowel_hole(height) {
    cylinder(h=height, r=dowel_radius, $fn=FN);
}

module drawer_confirmat_hole() {
    cylinder(h=melanine_thickness_secondary, r=confirmat_hole_radius, $fn=FN, center=true);
}

module drawer_confirmat_hole_threaded() {
    cylinder(h=confirmat_screw_length-melanine_thickness_secondary, r=confirmat_hole_radius, $fn=FN);
}

module handle_hole() {
    cylinder(h=melanine_thickness_main, r=handle_hole_diameter/2, $fn=FN, center=true);
}

module slide_pilot_hole() {
    cylinder(h=slide_pilot_hole_depth, r=slide_pilot_hole_radius, $fn=FN);
}

// --- Hole Metadata Export ---

function get_corpus_side_hole_2d_coords(x, y, z, is_left) = is_left ? [-z + corpus_height, y] : [z, y];
function get_drawer_side_hole_2d_coords(x, y, z, is_left) = is_left ? [drawer_depth - y, z] : [y, z];
function get_drawer_back_hole_2d_coords(x, y, z) = [x, z];
function get_drawer_bottom_hole_2d_coords(x, y, z) = [x, y];
function get_drawer_front_hole_2d_coords(x, y, z) = [x, z];
function get_shelf_hole_2d_coords(x, y, z) = [x, y];
function get_pedestal_front_back_hole_2d_coords(x, y, z) = [x, -z + pedestal_height];
function get_pedestal_side_hole_2d_coords(x, y, z) = [z, y];

module corpus_side_hole_metadata(is_left) {
    p1 = get_corpus_side_hole_2d_coords(melanine_thickness_main / 2, confirmat_hole_edge_distance, melanine_thickness_main / 2, is_left);
    echo(str("Hole,", export_panel_name, ",confirmat_bottom_1,", p1[0], ",", p1[1], ",0,", confirmat_hole_diameter, ",", melanine_thickness_main));
    p2 = get_corpus_side_hole_2d_coords(melanine_thickness_main / 2, corpus_depth - confirmat_hole_edge_distance, melanine_thickness_main / 2, is_left);
    echo(str("Hole,", export_panel_name, ",confirmat_bottom_2,", p2[0], ",", p2[1], ",0,", confirmat_hole_diameter, ",", melanine_thickness_main));
    p3 = get_corpus_side_hole_2d_coords(melanine_thickness_main / 2, confirmat_hole_edge_distance, corpus_height - melanine_thickness_main / 2, is_left);
    echo(str("Hole,", export_panel_name, ",confirmat_top_1,", p3[0], ",", p3[1], ",0,", confirmat_hole_diameter, ",", melanine_thickness_main));
    p4 = get_corpus_side_hole_2d_coords(melanine_thickness_main / 2, corpus_depth - confirmat_hole_edge_distance, corpus_height - melanine_thickness_main / 2, is_left);
    echo(str("Hole,", export_panel_name, ",confirmat_top_2,", p4[0], ",", p4[1], ",0,", confirmat_hole_diameter, ",", melanine_thickness_main));
    p5 = get_corpus_side_hole_2d_coords(melanine_thickness_main / 2, confirmat_hole_edge_distance, middle_plate_z + melanine_thickness_main / 2, is_left);
    echo(str("Hole,", export_panel_name, ",confirmat_middle_1,", p5[0], ",", p5[1], ",0,", confirmat_hole_diameter, ",", melanine_thickness_main));
    p6 = get_corpus_side_hole_2d_coords(melanine_thickness_main / 2, corpus_depth - confirmat_hole_edge_distance, middle_plate_z + melanine_thickness_main / 2, is_left);
    echo(str("Hole,", export_panel_name, ",confirmat_middle_2,", p6[0], ",", p6[1], ",0,", confirmat_hole_diameter, ",", melanine_thickness_main));
    for (i = [0:1]) {
        z = middle_plate_z + (i + 1) * (melanine_thickness_main + bookcase_shelf_gap) + melanine_thickness_main / 2;
        p7 = get_corpus_side_hole_2d_coords(melanine_thickness_main / 2, confirmat_hole_edge_distance, z, is_left);
        echo(str("Hole,", export_panel_name, ",confirmat_shelf_", i, "_1,", p7[0], ",", p7[1], ",0,", confirmat_hole_diameter, ",", melanine_thickness_main));
        p8 = get_corpus_side_hole_2d_coords(melanine_thickness_main / 2, corpus_depth - confirmat_hole_edge_distance, z, is_left);
        echo(str("Hole,", export_panel_name, ",confirmat_shelf_", i, "_2,", p8[0], ",", p8[1], ",0,", confirmat_hole_diameter, ",", melanine_thickness_main));
    }
    for (i = [0:number_of_drawers-1]) {
        z_slide = drawer_origin_z + i * drawer_vertical_space + slide_z_offset + slide_height / 2;
        for (j = [0:len(corpus_slide_pilot_hole_offsets)-1]) {
            offset = corpus_slide_pilot_hole_offsets[j];
            x_slide = is_left ? melanine_thickness_main : 0;
            p9 = get_corpus_side_hole_2d_coords(x_slide, offset, z_slide, is_left);
            echo(str("Hole,", export_panel_name, ",slide_pilot_", i, "_", j, ",", p9[0], ",", p9[1], ",0,", slide_pilot_hole_diameter, ",", slide_pilot_hole_depth));
        }
    }
}

module drawer_side_hole_metadata(is_left) {
    p1 = get_drawer_side_hole_2d_coords(melanine_thickness_secondary/2, drawer_depth - melanine_thickness_secondary/2, confirmat_hole_edge_distance, is_left);
    echo(str("Hole,", export_panel_name, ",back_panel_1,", p1[0], ",", p1[1], ",0,", confirmat_hole_diameter, ",", melanine_thickness_secondary));
    p2 = get_drawer_side_hole_2d_coords(melanine_thickness_secondary/2, drawer_depth - melanine_thickness_secondary/2, drawer_height - confirmat_hole_edge_distance, is_left);
    echo(str("Hole,", export_panel_name, ",back_panel_2,", p2[0], ",", p2[1], ",0,", confirmat_hole_diameter, ",", melanine_thickness_secondary));
    p3 = get_drawer_side_hole_2d_coords(melanine_thickness_secondary/2, confirmat_hole_edge_distance, melanine_thickness_secondary/2, is_left);
    echo(str("Hole,", export_panel_name, ",bottom_panel_1,", p3[0], ",", p3[1], ",0,", confirmat_hole_diameter, ",", melanine_thickness_secondary));
    p4 = get_drawer_side_hole_2d_coords(melanine_thickness_secondary/2, drawer_depth - confirmat_hole_edge_distance, melanine_thickness_secondary/2, is_left);
    echo(str("Hole,", export_panel_name, ",bottom_panel_2,", p4[0], ",", p4[1], ",0,", confirmat_hole_diameter, ",", melanine_thickness_secondary));
    p5 = get_drawer_side_hole_2d_coords(melanine_thickness_secondary/2, 0, dowel_hole_edge_distance, is_left);
    echo(str("Hole,", export_panel_name, ",dowel_front_1,", p5[0], ",", p5[1], ",", melanine_thickness_secondary/2, ",", dowel_diameter, ",", dowel_length - dowel_hole_depth_in_front));
    p6 = get_drawer_side_hole_2d_coords(melanine_thickness_secondary/2, 0, drawer_height - dowel_hole_edge_distance, is_left);
    echo(str("Hole,", export_panel_name, ",dowel_front_2,", p6[0], ",", p6[1], ",", melanine_thickness_secondary/2, ",", dowel_diameter, ",", dowel_length - dowel_hole_depth_in_front));
    z_pos = slide_z_offset + slide_height/2;
    for (offset = drawer_slide_pilot_hole_offsets) {
        x_pos = is_left ? 0 : melanine_thickness_secondary;
        p7 = get_drawer_side_hole_2d_coords(x_pos, offset, z_pos, is_left);
        echo(str("Hole,", export_panel_name, ",slide_pilot_", offset, ",", p7[0], ",", p7[1], ",0,", slide_pilot_hole_diameter, ",", slide_pilot_hole_depth));
    }
}

module drawer_back_hole_metadata() {
    p1 = get_drawer_back_hole_2d_coords(0, melanine_thickness_secondary/2, confirmat_hole_edge_distance);
    echo(str("Hole,", export_panel_name, ",left_side_1,", p1[0], ",", p1[1], ",", melanine_thickness_secondary/2, ",", confirmat_hole_diameter, ",", confirmat_screw_length - melanine_thickness_secondary));
    p2 = get_drawer_back_hole_2d_coords(0, melanine_thickness_secondary/2, drawer_height - confirmat_hole_edge_distance);
    echo(str("Hole,", export_panel_name, ",left_side_2,", p2[0], ",", p2[1], ",", melanine_thickness_secondary/2, ",", confirmat_hole_diameter, ",", confirmat_screw_length - melanine_thickness_secondary));
    p3 = get_drawer_back_hole_2d_coords(drawer_body_width, melanine_thickness_secondary/2, confirmat_hole_edge_distance);
    echo(str("Hole,", export_panel_name, ",right_side_1,", p3[0], ",", p3[1], ",", melanine_thickness_secondary/2, ",", confirmat_hole_diameter, ",", confirmat_screw_length - melanine_thickness_secondary));
    p4 = get_drawer_back_hole_2d_coords(drawer_body_width, melanine_thickness_secondary/2, drawer_height - confirmat_hole_edge_distance);
    echo(str("Hole,", export_panel_name, ",right_side_2,", p4[0], ",", p4[1], ",", melanine_thickness_secondary/2, ",", confirmat_hole_diameter, ",", confirmat_screw_length - melanine_thickness_secondary));
    p5 = get_drawer_back_hole_2d_coords(confirmat_hole_edge_distance, melanine_thickness_secondary/2, melanine_thickness_secondary/2);
    echo(str("Hole,", export_panel_name, ",bottom_panel_1,", p5[0], ",", p5[1], ",0,", confirmat_hole_diameter, ",", melanine_thickness_secondary));
    p6 = get_drawer_back_hole_2d_coords(drawer_body_width/2, melanine_thickness_secondary/2, melanine_thickness_secondary/2);
    echo(str("Hole,", export_panel_name, ",bottom_panel_2,", p6[0], ",", p6[1], ",0,", confirmat_hole_diameter, ",", melanine_thickness_secondary));
    p7 = get_drawer_back_hole_2d_coords(drawer_body_width - confirmat_hole_edge_distance, melanine_thickness_secondary/2, melanine_thickness_secondary/2);
    echo(str("Hole,", export_panel_name, ",bottom_panel_3,", p7[0], ",", p7[1], ",0,", confirmat_hole_diameter, ",", melanine_thickness_secondary));
}

module drawer_bottom_hole_metadata() {
    p1 = get_drawer_bottom_hole_2d_coords(0, confirmat_hole_edge_distance, melanine_thickness_secondary/2);
    echo(str("Hole,", export_panel_name, ",left_side_1,", p1[0], ",", p1[1], ",", melanine_thickness_secondary/2, ",", confirmat_hole_diameter, ",", confirmat_screw_length - melanine_thickness_secondary));
    p2 = get_drawer_bottom_hole_2d_coords(0, drawer_depth - melanine_thickness_secondary - confirmat_hole_edge_distance, melanine_thickness_secondary/2);
    echo(str("Hole,", export_panel_name, ",left_side_2,", p2[0], ",", p2[1], ",", melanine_thickness_secondary/2, ",", confirmat_hole_diameter, ",", confirmat_screw_length - melanine_thickness_secondary));
    p3 = get_drawer_bottom_hole_2d_coords(drawer_body_width, confirmat_hole_edge_distance, melanine_thickness_secondary/2);
    echo(str("Hole,", export_panel_name, ",right_side_1,", p3[0], ",", p3[1], ",", melanine_thickness_secondary/2, ",", confirmat_hole_diameter, ",", confirmat_screw_length - melanine_thickness_secondary));
    p4 = get_drawer_bottom_hole_2d_coords(drawer_body_width, drawer_depth - melanine_thickness_secondary - confirmat_hole_edge_distance, melanine_thickness_secondary/2);
    echo(str("Hole,", export_panel_name, ",right_side_2,", p4[0], ",", p4[1], ",", melanine_thickness_secondary/2, ",", confirmat_hole_diameter, ",", confirmat_screw_length - melanine_thickness_secondary));
    p5 = get_drawer_bottom_hole_2d_coords(confirmat_hole_edge_distance, drawer_depth - melanine_thickness_secondary, melanine_thickness_secondary/2);
    echo(str("Hole,", export_panel_name, ",back_panel_1,", p5[0], ",", p5[1], ",", melanine_thickness_secondary/2, ",", confirmat_hole_diameter, ",", confirmat_screw_length - melanine_thickness_secondary));
    p6 = get_drawer_bottom_hole_2d_coords(drawer_body_width/2, drawer_depth - melanine_thickness_secondary, melanine_thickness_secondary/2);
    echo(str("Hole,", export_panel_name, ",back_panel_2,", p6[0], ",", p6[1], ",", melanine_thickness_secondary/2, ",", confirmat_hole_diameter, ",", confirmat_screw_length - melanine_thickness_secondary));
    p7 = get_drawer_bottom_hole_2d_coords(drawer_body_width - confirmat_hole_edge_distance, drawer_depth - melanine_thickness_secondary, melanine_thickness_secondary/2);
    echo(str("Hole,", export_panel_name, ",back_panel_3,", p7[0], ",", p7[1], ",", melanine_thickness_secondary/2, ",", confirmat_hole_diameter, ",", confirmat_screw_length - melanine_thickness_secondary));
    p8 = get_drawer_bottom_hole_2d_coords(dowel_hole_edge_distance, 0, melanine_thickness_secondary/2);
    echo(str("Hole,", export_panel_name, ",dowel_front_1,", p8[0], ",", p8[1], ",", melanine_thickness_secondary/2, ",", dowel_diameter, ",", dowel_length - dowel_hole_depth_in_front));
    p9 = get_drawer_bottom_hole_2d_coords(drawer_body_width - dowel_hole_edge_distance, 0, melanine_thickness_secondary/2);
    echo(str("Hole,", export_panel_name, ",dowel_front_2,", p9[0], ",", p9[1], ",", melanine_thickness_secondary/2, ",", dowel_diameter, ",", dowel_length - dowel_hole_depth_in_front));
    if (drawer_body_width > panel_length_for_four_dowels) {
        x_offset = (drawer_body_width - 2 * dowel_hole_edge_distance) / 3;
        p10 = get_drawer_bottom_hole_2d_coords(dowel_hole_edge_distance + x_offset, 0, melanine_thickness_secondary/2);
        echo(str("Hole,", export_panel_name, ",dowel_front_3,", p10[0], ",", p10[1], ",", melanine_thickness_secondary/2, ",", dowel_diameter, ",", dowel_length - dowel_hole_depth_in_front));
        p11 = get_drawer_bottom_hole_2d_coords(dowel_hole_edge_distance + 2 * x_offset, 0, melanine_thickness_secondary/2);
        echo(str("Hole,", export_panel_name, ",dowel_front_4,", p11[0], ",", p11[1], ",", melanine_thickness_secondary/2, ",", dowel_diameter, ",", dowel_length - dowel_hole_depth_in_front));
    }
}

module drawer_front_hole_metadata(height, handle_z) {
    p1 = get_drawer_front_hole_2d_coords((front_width - drawer_body_width)/2, melanine_thickness_main, dowel_hole_edge_distance);
    echo(str("Hole,", export_panel_name, ",left_side_1,", p1[0], ",", p1[1], ",0,", dowel_diameter, ",", dowel_hole_depth_in_front));
    p2 = get_drawer_front_hole_2d_coords((front_width - drawer_body_width)/2, melanine_thickness_main, height - dowel_hole_edge_distance);
    echo(str("Hole,", export_panel_name, ",left_side_2,", p2[0], ",", p2[1], ",0,", dowel_diameter, ",", dowel_hole_depth_in_front));
    p3 = get_drawer_front_hole_2d_coords(front_width - (front_width - drawer_body_width)/2, melanine_thickness_main, dowel_hole_edge_distance);
    echo(str("Hole,", export_panel_name, ",right_side_1,", p3[0], ",", p3[1], ",0,", dowel_diameter, ",", dowel_hole_depth_in_front));
    p4 = get_drawer_front_hole_2d_coords(front_width - (front_width - drawer_body_width)/2, melanine_thickness_main, height - dowel_hole_edge_distance);
    echo(str("Hole,", export_panel_name, ",right_side_2,", p4[0], ",", p4[1], ",0,", dowel_diameter, ",", dowel_hole_depth_in_front));
    p5 = get_drawer_front_hole_2d_coords((front_width - drawer_body_width)/2 + dowel_hole_edge_distance, melanine_thickness_main, melanine_thickness_secondary/2);
    echo(str("Hole,", export_panel_name, ",bottom_panel_1,", p5[0], ",", p5[1], ",0,", dowel_diameter, ",", dowel_hole_depth_in_front));
    p6 = get_drawer_front_hole_2d_coords((front_width - drawer_body_width)/2 + drawer_body_width - dowel_hole_edge_distance, melanine_thickness_main, melanine_thickness_secondary/2);
    echo(str("Hole,", export_panel_name, ",bottom_panel_2,", p6[0], ",", p6[1], ",0,", dowel_diameter, ",", dowel_hole_depth_in_front));
    if(drawer_body_width > panel_length_for_four_dowels) {
         x_offset = (drawer_body_width - 2 * dowel_hole_edge_distance) / 3;
         p7 = get_drawer_front_hole_2d_coords((front_width - drawer_body_width)/2 + dowel_hole_edge_distance + x_offset, melanine_thickness_main, melanine_thickness_secondary/2);
         echo(str("Hole,", export_panel_name, ",bottom_panel_3,", p7[0], ",", p7[1], ",0,", dowel_diameter, ",", dowel_hole_depth_in_front));
         p8 = get_drawer_front_hole_2d_coords((front_width - drawer_body_width)/2 + dowel_hole_edge_distance + 2 * x_offset, melanine_thickness_main, melanine_thickness_secondary/2);
         echo(str("Hole,", export_panel_name, ",bottom_panel_4,", p8[0], ",", p8[1], ",0,", dowel_diameter, ",", dowel_hole_depth_in_front));
    }
    p9 = get_drawer_front_hole_2d_coords(front_width/2 - handle_hole_spacing/2, melanine_thickness_main/2, handle_z);
    echo(str("Hole,", export_panel_name, ",handle_1,", p9[0], ",", p9[1], ",0,", handle_hole_diameter, ",", melanine_thickness_main));
    p10 = get_drawer_front_hole_2d_coords(front_width/2 + handle_hole_spacing/2, melanine_thickness_main/2, handle_z);
    echo(str("Hole,", export_panel_name, ",handle_2,", p10[0], ",", p10[1], ",0,", handle_hole_diameter, ",", melanine_thickness_main));
}

module shelf_hole_metadata() {
    p1 = get_shelf_hole_2d_coords(0, confirmat_hole_edge_distance, melanine_thickness_main / 2);
    echo(str("Hole,", export_panel_name, ",left_side_1,", p1[0], ",", p1[1], ",", melanine_thickness_main / 2, ",", confirmat_hole_diameter, ",", confirmat_screw_length - melanine_thickness_main));
    p2 = get_shelf_hole_2d_coords(0, shelf_depth - confirmat_hole_edge_distance, melanine_thickness_main / 2);
    echo(str("Hole,", export_panel_name, ",left_side_2,", p2[0], ",", p2[1], ",", melanine_thickness_main / 2, ",", confirmat_hole_diameter, ",", confirmat_screw_length - melanine_thickness_main));
    p3 = get_shelf_hole_2d_coords(shelf_width, confirmat_hole_edge_distance, melanine_thickness_main / 2);
    echo(str("Hole,", export_panel_name, ",right_side_1,", p3[0], ",", p3[1], ",", melanine_thickness_main / 2, ",", confirmat_hole_diameter, ",", confirmat_screw_length - melanine_thickness_main));
    p4 = get_shelf_hole_2d_coords(shelf_width, shelf_depth - confirmat_hole_edge_distance, melanine_thickness_main / 2);
    echo(str("Hole,", export_panel_name, ",right_side_2,", p4[0], ",", p4[1], ",", melanine_thickness_main / 2, ",", confirmat_hole_diameter, ",", confirmat_screw_length - melanine_thickness_main));
}

module pedestal_front_back_hole_metadata() {
    p1 = get_pedestal_front_back_hole_2d_coords(0, melanine_thickness_main/2, pedestal_height/2);
    echo(str("Hole,", export_panel_name, ",left_side,", p1[0], ",", p1[1], ",", melanine_thickness_main/2, ",", confirmat_hole_diameter, ",", confirmat_screw_length - melanine_thickness_main));
    p2 = get_pedestal_front_back_hole_2d_coords(shelf_width, melanine_thickness_main/2, pedestal_height/2);
    echo(str("Hole,", export_panel_name, ",right_side,", p2[0], ",", p2[1], ",", melanine_thickness_main/2, ",", confirmat_hole_diameter, ",", confirmat_screw_length - melanine_thickness_main));
}

module pedestal_side_hole_metadata() {
    p1 = get_pedestal_side_hole_2d_coords(melanine_thickness_main/2, melanine_thickness_main/2, pedestal_height/2);
    echo(str("Hole,", export_panel_name, ",front_panel,", p1[0], ",", p1[1], ",0,", confirmat_hole_diameter, ",", melanine_thickness_main));
    p2 = get_pedestal_side_hole_2d_coords(melanine_thickness_main/2, corpus_depth - melanine_thickness_main/2, pedestal_height/2);
    echo(str("Hole,", export_panel_name, ",back_panel,", p2[0], ",", p2[1], ",0,", confirmat_hole_diameter, ",", melanine_thickness_main));
}

module echo_hole_metadata() {
    if (export_panel_name == "CorpusSideLeft") {
        corpus_side_hole_metadata(is_left = true);
    } else if (export_panel_name == "CorpusSideRight") {
        corpus_side_hole_metadata(is_left = false);
    } else if (export_panel_name == "DrawerSideLeft") {
        drawer_side_hole_metadata(is_left = true);
    } else if (export_panel_name == "DrawerSideRight") {
        drawer_side_hole_metadata(is_left = false);
    } else if (export_panel_name == "DrawerBack") {
        drawer_back_hole_metadata();
    } else if (export_panel_name == "DrawerBottom") {
        drawer_bottom_hole_metadata();
    } else if (export_panel_name == "DrawerFrontFirst") {
        drawer_front_hole_metadata(front_height_first, drawer_origin_z + drawer_height / 2);
    } else if (export_panel_name == "DrawerFrontStandard") {
        drawer_front_hole_metadata(front_height_standard, drawer_height / 2 + front_overhang);
    } else if (export_panel_name == "DrawerFrontTop") {
        drawer_front_hole_metadata(front_height_top, drawer_height / 2 + front_overhang);
    } else if (export_panel_name == "Shelf" || export_panel_name == "CorpusTopBottom" || export_panel_name == "CorpusMiddle") {
        shelf_hole_metadata();
    } else if (export_panel_name == "PedestalFrontBack") {
        pedestal_front_back_hole_metadata();
    } else if (export_panel_name == "PedestalSide") {
        pedestal_side_hole_metadata();
    }
}



module corpus_side_cut() {
    cube([melanine_thickness_main, corpus_depth, corpus_height]);
}

module corpus_side_drill(is_left = true) {
    // Holes for bottom plate
    translate([melanine_thickness_main / 2, confirmat_hole_edge_distance, melanine_thickness_main / 2]) rotate(ROT_Y_90) confirmat_hole_side();
    translate([melanine_thickness_main / 2, corpus_depth - confirmat_hole_edge_distance, melanine_thickness_main / 2]) rotate(ROT_Y_90) confirmat_hole_side();

    // Holes for top plate
    translate([melanine_thickness_main / 2, confirmat_hole_edge_distance, corpus_height - melanine_thickness_main / 2]) rotate(ROT_Y_90) confirmat_hole_side();
    translate([melanine_thickness_main / 2, corpus_depth - confirmat_hole_edge_distance, corpus_height - melanine_thickness_main / 2]) rotate(ROT_Y_90) confirmat_hole_side();

    // Holes for middle plate
    translate([melanine_thickness_main / 2, confirmat_hole_edge_distance, middle_plate_z + melanine_thickness_main / 2]) rotate(ROT_Y_90) confirmat_hole_side();
    translate([melanine_thickness_main / 2, corpus_depth - confirmat_hole_edge_distance, middle_plate_z + melanine_thickness_main / 2]) rotate(ROT_Y_90) confirmat_hole_side();

    // Holes for shelves
    for (i = [0:1]) {
        z = middle_plate_z + (i + 1) * (melanine_thickness_main + bookcase_shelf_gap) + melanine_thickness_main / 2;
        translate([melanine_thickness_main / 2, confirmat_hole_edge_distance, z]) rotate(ROT_Y_90) confirmat_hole_side();
        translate([melanine_thickness_main / 2, corpus_depth - confirmat_hole_edge_distance, z]) rotate(ROT_Y_90) confirmat_hole_side();
    }
    
    // Pilot holes for drawer slides
    for (i = [0:number_of_drawers-1]) {
        z = drawer_origin_z + i * drawer_vertical_space + slide_z_offset + slide_height / 2;
        for (offset = corpus_slide_pilot_hole_offsets) {
            if (is_left) {
                translate([melanine_thickness_main, offset, z]) rotate(ROT_Y_NEG_90) slide_pilot_hole();
            } else {
                translate([0, offset, z]) rotate(ROT_Y_90) slide_pilot_hole();
            }
        }
    }
}

module corpus_side(is_left = true) {
    difference() {
        union() {
            color(color_corpus, part_alpha)
            dxf_layer(CUT) corpus_side_cut();
        }
        dxf_layer(DRILL) corpus_side_drill(is_left);
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
    translate([melanine_thickness_main, 0, 0]) shelf();

    // Top plate
    translate([melanine_thickness_main, 0, corpus_height - melanine_thickness_main]) shelf();

    // Middle plate
    translate([melanine_thickness_main, 0, middle_plate_z]) shelf();
}



module drawer_side_cut() {
    cube([melanine_thickness_secondary, drawer_depth, drawer_height]);
}

module drawer_side_drill(is_left = true) {
    // Holes for back panel (2 holes)
    translate([melanine_thickness_secondary/2, drawer_depth - melanine_thickness_secondary/2, confirmat_hole_edge_distance]) rotate(ROT_Y_90) drawer_confirmat_hole();
    translate([melanine_thickness_secondary/2, drawer_depth - melanine_thickness_secondary/2, drawer_height - confirmat_hole_edge_distance]) rotate(ROT_Y_90) drawer_confirmat_hole();

    // Holes for bottom panel (2 holes)
    translate([melanine_thickness_secondary/2, confirmat_hole_edge_distance, melanine_thickness_secondary/2]) rotate(ROT_Y_90) drawer_confirmat_hole();
    translate([melanine_thickness_secondary/2, drawer_depth - confirmat_hole_edge_distance, melanine_thickness_secondary/2]) rotate(ROT_Y_90) drawer_confirmat_hole();

    // Dowel holes for front panel
    translate([melanine_thickness_secondary/2, 0, dowel_hole_edge_distance]) rotate(ROT_X_90) dowel_hole(dowel_length - dowel_hole_depth_in_front);
    translate([melanine_thickness_secondary/2, 0, drawer_height - dowel_hole_edge_distance]) rotate(ROT_X_90) dowel_hole(dowel_length - dowel_hole_depth_in_front);
    
    // Pilot holes for slides
    z_pos = slide_z_offset + slide_height/2;
    for (offset = drawer_slide_pilot_hole_offsets) {
        if (is_left) {
            translate([0, offset, z_pos]) rotate(ROT_Y_90) slide_pilot_hole();
        } else {
            translate([melanine_thickness_secondary, offset, z_pos]) rotate(ROT_Y_NEG_90) slide_pilot_hole();
        }
    }
}

module drawer_side(is_left = true) {
    difference() {
        union() {
            color(color_drawers, part_alpha)
            dxf_layer(CUT) drawer_side_cut();
        }
        dxf_layer(DRILL) drawer_side_drill(is_left);
    }
}

module drawer_back_cut() {
    cube([drawer_body_width, melanine_thickness_secondary, drawer_height]);
}

module drawer_back_drill() {
    // Holes for left side (2 holes)
    translate([0, melanine_thickness_secondary/2, confirmat_hole_edge_distance]) rotate(ROT_Y_90) drawer_confirmat_hole_threaded();
    translate([0, melanine_thickness_secondary/2, drawer_height - confirmat_hole_edge_distance]) rotate(ROT_Y_90) drawer_confirmat_hole_threaded();

    // Holes for right side (2 holes)
    translate([drawer_body_width, melanine_thickness_secondary/2, confirmat_hole_edge_distance]) rotate(ROT_Y_NEG_90) drawer_confirmat_hole_threaded();
    translate([drawer_body_width, melanine_thickness_secondary/2, drawer_height - confirmat_hole_edge_distance]) rotate(ROT_Y_NEG_90) drawer_confirmat_hole_threaded();

    // Holes for bottom panel (3 holes)
    translate([confirmat_hole_edge_distance, melanine_thickness_secondary/2, melanine_thickness_secondary/2]) rotate(ROT_X_90) drawer_confirmat_hole();
    translate([drawer_body_width/2, melanine_thickness_secondary/2, melanine_thickness_secondary/2]) rotate(ROT_X_90) drawer_confirmat_hole();
    translate([drawer_body_width - confirmat_hole_edge_distance, melanine_thickness_secondary/2, melanine_thickness_secondary/2]) rotate(ROT_X_90) drawer_confirmat_hole();
}



module drawer_back() {
    difference() {
        union() {
            color(color_drawer_back, part_alpha)
            dxf_layer(CUT) drawer_back_cut();
        }
        dxf_layer(DRILL) drawer_back_drill();
    }
}

module drawer_bottom_cut() {
    cube([drawer_body_width, drawer_depth - melanine_thickness_secondary, melanine_thickness_secondary]);
}

module drawer_bottom_drill() {
    // Holes for left side (2 holes)
    translate([0, confirmat_hole_edge_distance, melanine_thickness_secondary/2]) rotate(ROT_Y_90) drawer_confirmat_hole_threaded();
    translate([0, drawer_depth - melanine_thickness_secondary - confirmat_hole_edge_distance, melanine_thickness_secondary/2]) rotate(ROT_Y_90) drawer_confirmat_hole_threaded();

    // Holes for right side (2 holes)
    translate([drawer_body_width, confirmat_hole_edge_distance, melanine_thickness_secondary/2]) rotate(ROT_Y_NEG_90) drawer_confirmat_hole_threaded();
    translate([drawer_body_width, drawer_depth - melanine_thickness_secondary - confirmat_hole_edge_distance, melanine_thickness_secondary/2]) rotate(ROT_Y_NEG_90) drawer_confirmat_hole_threaded();

    // Holes for back panel (3 holes)
    translate([confirmat_hole_edge_distance, drawer_depth - melanine_thickness_secondary, melanine_thickness_secondary/2]) rotate(ROT_X_90) drawer_confirmat_hole_threaded();
    translate([drawer_body_width/2, drawer_depth - melanine_thickness_secondary, melanine_thickness_secondary/2]) rotate(ROT_X_90) drawer_confirmat_hole_threaded();
    translate([drawer_body_width - confirmat_hole_edge_distance, drawer_depth - melanine_thickness_secondary, melanine_thickness_secondary/2]) rotate(ROT_X_90) drawer_confirmat_hole_threaded();

    // Dowel holes for front panel
    translate([dowel_hole_edge_distance, 0, melanine_thickness_secondary/2]) rotate(ROT_X_90) dowel_hole(dowel_length - dowel_hole_depth_in_front);
    translate([drawer_body_width - dowel_hole_edge_distance, 0, melanine_thickness_secondary/2]) rotate(ROT_X_90) dowel_hole(dowel_length - dowel_hole_depth_in_front);
    if (drawer_body_width > panel_length_for_four_dowels) {
        x_offset = (drawer_body_width - 2 * dowel_hole_edge_distance) / 3;
        translate([dowel_hole_edge_distance + x_offset, 0, melanine_thickness_secondary/2]) rotate(ROT_X_90) dowel_hole(dowel_length - dowel_hole_depth_in_front);
        translate([dowel_hole_edge_distance + 2 * x_offset, 0, melanine_thickness_secondary/2]) rotate(ROT_X_90) dowel_hole(dowel_length - dowel_hole_depth_in_front);
    }
}

module drawer_bottom() {
    difference() {
        union() {
            color(color_drawers, part_alpha)
            dxf_layer(CUT) drawer_bottom_cut();
        }
        dxf_layer(DRILL) drawer_bottom_drill();
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



module drawer_front_cut(height) {
    cube([front_width, melanine_thickness_main, height]);
}

module drawer_front_drill(height, handle_z) {
    // Dowel holes for left drawer side panel
    translate([(front_width - drawer_body_width)/2, melanine_thickness_main, dowel_hole_edge_distance]) rotate(ROT_X_NEG_90) dowel_hole(dowel_hole_depth_in_front);
    translate([(front_width - drawer_body_width)/2, melanine_thickness_main, height - dowel_hole_edge_distance]) rotate(ROT_X_NEG_90) dowel_hole(dowel_hole_depth_in_front);

    // Dowel holes for right drawer side panel
    translate([front_width - (front_width - drawer_body_width)/2, melanine_thickness_main, dowel_hole_edge_distance]) rotate(ROT_X_NEG_90) dowel_hole(dowel_hole_depth_in_front);
    translate([front_width - (front_width - drawer_body_width)/2, melanine_thickness_main, height - dowel_hole_edge_distance]) rotate(ROT_X_NEG_90) dowel_hole(dowel_hole_depth_in_front);

    // Dowel holes for drawer bottom panel
    translate([(front_width - drawer_body_width)/2 + dowel_hole_edge_distance, melanine_thickness_main, melanine_thickness_secondary/2]) rotate(ROT_X_NEG_90) dowel_hole(dowel_hole_depth_in_front);
    translate([(front_width - drawer_body_width)/2 + drawer_body_width - dowel_hole_edge_distance, melanine_thickness_main, melanine_thickness_secondary/2]) rotate(ROT_X_NEG_90) dowel_hole(dowel_hole_depth_in_front);
    if(drawer_body_width > panel_length_for_four_dowels) {
         x_offset = (drawer_body_width - 2 * dowel_hole_edge_distance) / 3;
         translate([(front_width - drawer_body_width)/2 + dowel_hole_edge_distance + x_offset, melanine_thickness_main, melanine_thickness_secondary/2]) rotate(ROT_X_NEG_90) dowel_hole(dowel_hole_depth_in_front);
         translate([(front_width - drawer_body_width)/2 + dowel_hole_edge_distance + 2 * x_offset, melanine_thickness_main, melanine_thickness_secondary/2]) rotate(ROT_X_NEG_90) dowel_hole(dowel_hole_depth_in_front);
    }
    
    // Handle holes
    translate([front_width/2 - handle_hole_spacing/2, melanine_thickness_main/2, handle_z]) rotate(ROT_X_90) handle_hole();
    translate([front_width/2 + handle_hole_spacing/2, melanine_thickness_main/2, handle_z]) rotate(ROT_X_90) handle_hole();
}

module drawer_front(height, handle_z) {
    difference() {
        union() {
            color(color_fronts, part_alpha)
            dxf_layer(CUT) drawer_front_cut(height);
        }
        dxf_layer(DRILL) drawer_front_drill(height, handle_z);
    }
}



module slide() {
    color(color_slides, part_alpha)
    cube([slide_depth, slide_width, slide_height]);
}



module shelf_cut() {
    cube([shelf_width, shelf_depth, melanine_thickness_main]);
}

module shelf_drill() {
    // Holes for left side
    translate([0, confirmat_hole_edge_distance, melanine_thickness_main / 2]) rotate(ROT_Y_90) confirmat_hole_plate();
    translate([0, shelf_depth - confirmat_hole_edge_distance, melanine_thickness_main / 2]) rotate(ROT_Y_90) confirmat_hole_plate();

    // Holes for right side
    translate([shelf_width, confirmat_hole_edge_distance, melanine_thickness_main / 2]) rotate(ROT_Y_NEG_90) confirmat_hole_plate();
    translate([shelf_width, shelf_depth - confirmat_hole_edge_distance, melanine_thickness_main / 2]) rotate(ROT_Y_NEG_90) confirmat_hole_plate();
}

module shelf() {
    difference() {
        union() {
            color(color_shelves, part_alpha)
            dxf_layer(CUT) shelf_cut();
        }
        dxf_layer(DRILL) shelf_drill();
    }
}



module glass_door() {
    color(color_glass, 0.5)
    cube([bookcase_glass_door_width, bookcase_glass_door_tickness, bookcase_glass_door_height]);
}



module hdf_back_panel_cut() {
    cube([corpus_width, hdf_thickness, corpus_height]);
}

module hdf_back_panel() {
    color(color_hdf_panel, part_alpha)
    dxf_layer(CUT) hdf_back_panel_cut();
}



module pedestal_front_back_cut() {
    cube([shelf_width, melanine_thickness_main, pedestal_height]);
}

module pedestal_front_back_drill() {
    // Holes for left side
    translate([0, melanine_thickness_main/2, pedestal_height/2]) rotate(ROT_Y_90) confirmat_hole_plate();
    
    // Holes for right side
    translate([shelf_width, melanine_thickness_main/2, pedestal_height/2]) rotate(ROT_Y_NEG_90) confirmat_hole_plate();
}

module pedestal_front_back() {
    difference() {
        union() {
            pedestal_front_back_cut();
        }
        pedestal_front_back_drill();
    }
}

module pedestal_side_cut() {
    cube([melanine_thickness_main, corpus_depth, pedestal_height]);
}

module pedestal_side_drill() {
    // Hole for front panel
    translate([melanine_thickness_main/2, melanine_thickness_main/2, pedestal_height/2]) rotate(ROT_Y_90) confirmat_hole_side();
    
    // Hole for back panel
    translate([melanine_thickness_main/2, corpus_depth - melanine_thickness_main/2, pedestal_height/2]) rotate(ROT_Y_90) confirmat_hole_side();
}

module pedestal_side() {
    difference() {
        union() {
            pedestal_side_cut();
        }
        pedestal_side_drill();
    }
}

module pedestal() {
    color(color_pedestal, part_alpha) {
        // Front
        translate([melanine_thickness_main, 0, -pedestal_height])
        pedestal_front_back();

        // Back
        translate([melanine_thickness_main, corpus_depth - melanine_thickness_main, -pedestal_height])
        pedestal_front_back();

        // Left
        translate([0, 0, -pedestal_height])
        pedestal_side();

        // Right
        translate([corpus_width - melanine_thickness_main, 0, -pedestal_height])
        pedestal_side();
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
    echo("material code,material thickness,dimension A (along wood grain),dimension B,count,edge banding A-1,edge banding A-2,edge banding B-1,edge banding B-2,panel name,panel description,cnc face holes,cnc side holes");

    // Corpus
    echo(str("MEL-19,", melanine_thickness_main, ",", corpus_height, ",", corpus_depth, ",1,1,0,1,1,CorpusSideLeft,Vertical side panel of the main body,cnc: rupe fi4mm za konfirmat + pilot fi2.5mm za vodilice,"));
    echo(str("MEL-19,", melanine_thickness_main, ",", corpus_height, ",", corpus_depth, ",1,1,0,1,1,CorpusSideRight,Vertical side panel of the main body,cnc: rupe fi4mm za konfirmat + pilot fi2.5mm za vodilice,"));
    echo(str("MEL-19,", melanine_thickness_main, ",", shelf_width, ",", shelf_depth, ",2,1,0,0,0,CorpusTopBottom,Horizontal top and bottom panels,,cnc: rubne rupe fi4mm za konfirmat"));
    echo(str("MEL-19,", melanine_thickness_main, ",", shelf_width, ",", shelf_depth, ",1,1,0,0,0,CorpusMiddle,Horizontal shelf separating drawers and bookcase,,cnc: rubne rupe fi4mm za konfirmat"));

    // Drawers
    echo(str("MEL-12,", melanine_thickness_secondary, ",", drawer_depth, ",", drawer_height, ",6,1,1,1,1,DrawerSideLeft,Vertical side panel of a drawer,cnc: rupe fi4mm za konfirmat + pilot fi2.5mm za vodilice,cnc: rubne rupe fi6mm za tiple"));
    echo(str("MEL-12,", melanine_thickness_secondary, ",", drawer_depth, ",", drawer_height, ",6,1,1,1,1,DrawerSideRight,Vertical side panel of a drawer,cnc: rupe fi4mm za konfirmat + pilot fi2.5mm za vodilice,cnc: rubne rupe fi6mm za tiple"));
    echo(str("MEL-12,", melanine_thickness_secondary, ",", drawer_body_width, ",", drawer_height, ",6,1,1,0,0,DrawerBack,Vertical back panel of a drawer,cnc: rupe fi4mm za konfirmat,cnc: rubne rupe fi4mm za konfirmat"));
    echo(str("MEL-12,", melanine_thickness_secondary, ",", drawer_body_width, ",", drawer_depth - melanine_thickness_secondary, ",6,0,0,0,0,DrawerBottom,Bottom panel of a drawer,,cnc: rubne rupe fi4mm za konfirmat + fi6mm za tiple"));

    // Drawer Fronts
    echo(str("MEL-19,", melanine_thickness_main, ",", front_width, ",", front_height_first, ",1,1,1,1,1,DrawerFrontFirst,Front panel for the bottom drawer,cnc: rupe fi6mm D10mm tiple,"));
    echo(str("MEL-19,", melanine_thickness_main, ",", front_width, ",", front_height_standard, ",4,1,1,1,1,DrawerFrontStandard,Front panel for the middle 4 drawers,cnc: rupe fi6mm D10mm tiple,"));
    echo(str("MEL-19,", melanine_thickness_main, ",", front_width, ",", front_height_top, ",1,1,1,1,1,DrawerFrontTop,Front panel for the top drawer,cnc: rupe fi6mm D10mm tiple,"));

    // Bookcase
    echo(str("MEL-19,", melanine_thickness_main, ",", shelf_width, ",", shelf_depth, ",2,1,0,0,0,Shelf,Shelf in the bookcase section,,cnc: rubne rupe fi4mm za konfirmat"));

    // Pedestal
    echo(str("MEL-19,", melanine_thickness_main, ",", shelf_width, ",", pedestal_height, ",2,1,0,0,0,PedestalFrontBack,Front and back panels of the pedestal,,cnc: rubne rupe fi4mm za konfirmat"));
    echo(str("MEL-19,", melanine_thickness_main, ",", corpus_depth, ",", pedestal_height, ",2,1,0,1,1,PedestalSide,Side panels of the pedestal,cnc: rupe fi4mm za konfirmat,"));

    // Back Panel
    echo(str("HDF-3,", hdf_thickness, ",", corpus_height, ",", corpus_width, ",1,0,0,0,0,HDFBackPanel,The back panel of the entire unit,,"));
}


function is_valid_panel_name(name) = len(search([name], panel_names)) > 0;

// DXF Export
// To export a panel, set the export_panel_name variable to one of the names in the 'panel_names' array.
//
// Then, from OpenSCAD, use File -> Export -> Export as DXF.
module flat_projection() {
    if (export_type == "dxf" || export_type == "svg") {
        projection(cut=true) children();
    } else {
        children();
    }
}

module export_panel(panel_name) {
    if (panel_name == "CorpusSideLeft") {
        translate([corpus_height, 0, 0])
        flat_projection() {
            rotate(ROT_Y_NEG_90) translate([-melanine_thickness_main, 0, 0]) corpus_side(is_left=true); 
        }
    } else if (panel_name == "CorpusSideRight") {
        flat_projection() {
            rotate(ROT_Y_90) corpus_side(is_left=false); 
        }
    } else if (panel_name == "CorpusTopBottom" || panel_name == "CorpusMiddle" || panel_name == "Shelf") {
        flat_projection() shelf();
    } else if (panel_name == "DrawerSideLeft") {
        translate([drawer_depth, 0, 0])
        flat_projection() {
            rotate(ROT_Z_90)
            rotate(ROT_Y_90) 
            drawer_side(is_left=true);
        }
    } else if (panel_name == "DrawerSideRight") {
        flat_projection() {
            rotate(ROT_Z_NEG_90)
            rotate(ROT_Y_NEG_90) 
            translate([-melanine_thickness_secondary, 0, 0]) 
            drawer_side(is_left=false);
        }
    } else if (panel_name == "DrawerBack") {
        flat_projection() {
            rotate(ROT_X_NEG_90) drawer_back();
        }
    } else if (panel_name == "DrawerBottom") {
        flat_projection() drawer_bottom();
    } else if (panel_name == "DrawerFrontFirst") {
        flat_projection() {
            rotate(ROT_X_NEG_90) translate([0, -melanine_thickness_main, 0]) drawer_front(front_height_first, drawer_origin_z + drawer_height / 2);
        }
    } else if (panel_name == "DrawerFrontStandard") {
        flat_projection() {
            rotate(ROT_X_NEG_90) translate([0, -melanine_thickness_main, 0]) drawer_front(front_height_standard, drawer_height / 2 + front_overhang);
        }
    } else if (panel_name == "DrawerFrontTop") {
        flat_projection() {
            rotate(ROT_X_NEG_90) translate([0, -melanine_thickness_main, 0]) drawer_front(front_height_top, drawer_height / 2 + front_overhang);
        }
    } else if (panel_name == "PedestalFrontBack") {
        translate([0, pedestal_height, 0])
        flat_projection() {
            rotate(ROT_X_90) pedestal_front_back();
        }
    } else if (panel_name == "PedestalSide") {
        flat_projection() {
            rotate(ROT_Y_90) pedestal_side();
        }
    } else if (panel_name == "HDFBackPanel") {
        translate([0, corpus_height, 0])
        flat_projection() {
            rotate(ROT_X_90) hdf_back_panel();
        }
    }
}

// ----------------------------------------- main

if (generate_model_identifier) {
    echo(model_identifier);
} else if (generate_panel_names_list) {
    for (p = panel_names) {
        echo(p);
    }
} else if (generate_cut_list_csv) {
    generate_cut_list();
} else if (export_panel_name != "") {
    if (is_valid_panel_name(export_panel_name)) {
        echo_hole_metadata();
        export_panel(export_panel_name);
    } else {
        echo(str("Warning: Invalid panel name '", export_panel_name, "'."));
        echo("Please use one of the following valid panel names:");
        for (p = panel_names) {
            echo(str(" - ", p));
        }
    }
} else {
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
}



