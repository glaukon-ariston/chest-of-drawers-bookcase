import ezdxf
import sys
import csv
import os

# Threshold for slot detection (in DXF units, e.g., mm)
SLOT_MAX_SIZE = 10.0

def add_hole_table(msp, holes, position):
    """Adds a table of hole information to the DXF."""
    if not holes:
        return 0

    # Table properties
    text_height = 2.5
    line_height = text_height * 1.5
    col_widths = {
        "name": 40,
        "x": 20,
        "y": 20,
        "z": 20,
        "diameter": 20,
        "depth": 20
    }
    header = ["Hole Name", "X", "Y", "Z", "Dia", "Depth"]
    keys = ["name", "x", "y", "z", "diameter", "depth"]
    entities_added = 0

    # Starting position
    x_start, y_start = position
    
    # Title
    msp.add_text(
        "Hole Schedule",
        dxfattribs={
            'layer': 'ANNOTATION',
            'height': text_height * 1.5,
            'insert': (x_start, y_start)
        }
    )
    entities_added += 1
    y_start -= line_height * 2

    # Draw header
    current_x = x_start
    for i, col_header in enumerate(header):
        msp.add_text(
            col_header,
            dxfattribs={
                'layer': 'ANNOTATION',
                'height': text_height,
                'insert': (current_x, y_start)
            }
        )
        current_x += col_widths[keys[i]]
    entities_added += len(header)

    # Draw header underline
    y = y_start - text_height / 2
    msp.add_line((x_start, y), (current_x, y), dxfattribs={'layer': 'ANNOTATION'})
    entities_added += 1

    # Draw rows
    y_start -= line_height * 1.5  # Additional space to account for header underline
    for hole in holes:
        current_x = x_start
        for key in keys:
            msp.add_text(
                str(hole[key]),
                dxfattribs={
                    'layer': 'ANNOTATION',
                    'height': text_height,
                    'insert': (current_x, y_start)
                }
            )
            current_x += col_widths[key]
        y_start -= line_height
    entities_added += len(holes) * len(keys)
    
    return entities_added


def add_hole_annotations_from_csv(msp, input_file):
    """Read a CSV file with the same name as the input DXF and add hole annotations."""
    csv_file = os.path.splitext(input_file)[0] + ".csv"
    annotations_added = 0
    holes = []
    if not os.path.exists(csv_file):
        print(f"No annotation file found at: {csv_file}")
        return annotations_added, holes

    print(f"Found annotation file: {csv_file}")
    with open(csv_file, mode='r', newline='') as f:
        # Skip the header row
        next(f)
        reader = csv.reader(f)
        for row in reader:
            try:
                # Unpack row data
                panel_name, hole_name, x, y, z, diameter, depth = row
                
                # Convert numeric values
                x = float(x)
                y = float(y)
                z = float(z)
                diameter = float(diameter)
                depth = float(depth)

                holes.append({
                    "name": hole_name,
                    "x": round(x, 2),
                    "y": round(y, 2),
                    "z": round(z, 2),
                    "diameter": diameter,
                    "depth": depth
                })
                
                if z != 0:
                    # Draw a small cross at the hole's (x,y) location
                    indicator_size = 6.0 # Length of each arm of the cross
                    
                    # Horizontal line
                    msp.add_line(
                        start=(x - indicator_size / 2, y),
                        end=(x + indicator_size / 2, y),
                        dxfattribs={
                            'layer': 'DRILL',
                            'color': 5 # Blue color for drill layer
                        }
                    )
                    # Vertical line
                    msp.add_line(
                        start=(x, y - indicator_size / 2),
                        end=(x, y + indicator_size / 2),
                        dxfattribs={
                            'layer': 'DRILL',
                            'color': 5 # Blue color for drill layer
                        }
                    )
                    print(f"  - Added side hole indicator: d{diameter} h{depth} z{z} at ({x}, {y})")

                # Create annotation text
                if z != 0:
                    text = f"d{diameter} h{depth} z{z}"
                else:
                    text = f"d{diameter} h{depth}"
                
                # Add text to the ANNOTATION layer
                msp.add_text(
                    text,
                    dxfattribs={
                        'layer': 'ANNOTATION',
                        'height': 2.5,  # Adjust height as needed
                        'insert': (x, y + 5)  # Offset Y for visibility
                    }
                )
                print(f"  - Added annotation: {text} at ({x}, {y})")
                annotations_added += 1
            except (ValueError, KeyError) as e:
                print(f"  - Warning: Skipping invalid row in CSV: {row} ({e})")
    return annotations_added, holes


def is_small_slot(poly):
    """Return True if polyline is closed and small enough to be considered a drill/slot."""
    if not poly.closed:
        return False
    points = poly.get_points()
    xs = [p[0] for p in points]
    ys = [p[1] for p in points]
    width = max(xs) - min(xs)
    height = max(ys) - min(ys)
    return width <= SLOT_MAX_SIZE and height <= SLOT_MAX_SIZE


def extract_entity_data(entity):
    """Extract all necessary data from an entity before it's deleted."""
    dtype = entity.dxftype()
    data = {'type': dtype}
    
    if dtype == "CIRCLE":
        data['center'] = entity.dxf.center
        data['radius'] = entity.dxf.radius
    elif dtype == "LINE":
        data['start'] = entity.dxf.start
        data['end'] = entity.dxf.end
    elif dtype == "ARC":
        data['center'] = entity.dxf.center
        data['radius'] = entity.dxf.radius
        data['start_angle'] = entity.dxf.start_angle
        data['end_angle'] = entity.dxf.end_angle
    elif dtype in ["LWPOLYLINE", "POLYLINE"]:
        points = list(entity.get_points())
        # Extract just the x,y coordinates (first two elements of each point)
        data['points'] = [(p[0], p[1]) for p in points]
        data['closed'] = entity.closed
    elif dtype == "TEXT":
        data['text'] = entity.dxf.text
        data['insert'] = entity.dxf.insert
        data['height'] = entity.dxf.height
        data['rotation'] = entity.dxf.rotation
    elif dtype == "MTEXT":
        data['text'] = entity.dxf.text
        data['insert'] = entity.dxf.insert
        data['char_height'] = entity.dxf.char_height
        data['rotation'] = entity.dxf.rotation
    else:
        raise ValueError(f"Unsupported entity type: {dtype}")
    
    # Copy common attributes
    if hasattr(entity.dxf, 'color'):
        data['color'] = entity.dxf.color
    
    return data


def create_new_entity(msp, data, target_layer):
    """Create a new entity from extracted data."""
    dtype = data['type']
    
    if dtype == "CIRCLE":
        new_entity = msp.add_circle(
            center=data['center'],
            radius=data['radius']
        )
    elif dtype == "LINE":
        new_entity = msp.add_line(
            start=data['start'],
            end=data['end']
        )
    elif dtype == "ARC":
        new_entity = msp.add_arc(
            center=data['center'],
            radius=data['radius'],
            start_angle=data['start_angle'],
            end_angle=data['end_angle']
        )
    elif dtype in ["LWPOLYLINE", "POLYLINE"]:
        new_entity = msp.add_lwpolyline(data['points'])
        new_entity.closed = data['closed']
    elif dtype == "TEXT":
        new_entity = msp.add_text(
            text=data['text'],
            dxfattribs={
                'insert': data['insert'],
                'height': data['height'],
                'rotation': data['rotation']
            }
        )
    elif dtype == "MTEXT":
        new_entity = msp.add_mtext(
            text=data['text'],
            dxfattribs={
                'insert': data['insert'],
                'char_height': data['char_height'],
                'rotation': data['rotation']
            }
        )
    else:
        raise ValueError(f"Unsupported entity type for creation: {dtype}")
    
    # Set the target layer
    new_entity.dxf.layer = target_layer
    
    # Copy other attributes
    if 'color' in data and data['color'] != 256:  # Not BYLAYER
        new_entity.dxf.color = data['color']
    
    return new_entity


def calculate_bounding_box(msp):
    """Calculate the bounding box of all entities in modelspace."""
    min_x = min_y = float('inf')
    max_x = max_y = float('-inf')
    
    for entity in msp:
        try:
            # Get entity's bounding box if available
            if hasattr(entity, 'bbox') and callable(entity.bbox):
                bbox = entity.bbox()
                if bbox:
                    min_x = min(min_x, bbox.extmin.x)
                    min_y = min(min_y, bbox.extmin.y)
                    max_x = max(max_x, bbox.extmax.x)
                    max_y = max(max_y, bbox.extmax.y)
                    continue
            
            # Fallback: extract coordinates based on entity type
            dtype = entity.dxftype()
            if dtype == "CIRCLE":
                cx, cy = entity.dxf.center[:2]
                r = entity.dxf.radius
                min_x = min(min_x, cx - r)
                min_y = min(min_y, cy - r)
                max_x = max(max_x, cx + r)
                max_y = max(max_y, cy + r)
            elif dtype == "LINE":
                x1, y1 = entity.dxf.start[:2]
                x2, y2 = entity.dxf.end[:2]
                min_x = min(min_x, x1, x2)
                min_y = min(min_y, y1, y2)
                max_x = max(max_x, x1, x2)
                max_y = max(max_y, y1, y2)
            elif dtype == "ARC":
                # Simplified: use center +/- radius (not exact for arcs)
                cx, cy = entity.dxf.center[:2]
                r = entity.dxf.radius
                min_x = min(min_x, cx - r)
                min_y = min(min_y, cy - r)
                max_x = max(max_x, cx + r)
                max_y = max(max_y, cy + r)
            elif dtype in ["LWPOLYLINE", "POLYLINE"]:
                points = list(entity.get_points())
                for point in points:
                    x, y = point[:2]
                    min_x = min(min_x, x)
                    min_y = min(min_y, y)
                    max_x = max(max_x, x)
                    max_y = max(max_y, y)
            elif dtype in ["TEXT", "MTEXT"]:
                x, y = entity.dxf.insert[:2]
                min_x = min(min_x, x)
                min_y = min(min_y, y)
                max_x = max(max_x, x)
                max_y = max(max_y, y)
        except Exception:
            # Skip entities that can't be processed
            continue
    
    if min_x == float('inf'):
        # No entities found, return default
        return 0, 0, 0, 0
    
    return min_x, min_y, max_x, max_y


def add_dimensions(msp, holes, bounding_box, doc):
    """Adds dimension lines for the panel and holes, optimizing for clarity."""
    # Ensure a dimension style exists
    if "Standard" not in doc.dimstyles:
        style = doc.dimstyles.new(
            "Standard",
            dxfattribs={
                "dimtxsty": "OpenSans",
                "dimtxt": 3.5,          # Text height
                "dimasz": 2.5,          # Arrow size
                "dimclrt": 7,           # Dimension line color
                "dimtad": 0,            # Center text on dimension line (breaks the line)
                "dimgap": 0.5,          # Small gap when text is centered
                "dimtfill": 1,          # Use background fill for text
                "dimtfillclr": 0,       # White background fill
                "dimexe": 1.25,         # Extension line extension beyond dimension line
                "dimexo": 0.625,        # Extension line offset from origin
                "dimtih": 1,            # Text inside extensions is horizontal
                "dimtoh": 1,            # Text outside extensions is horizontal
                "dimtofl": 0,           # Don't force line inside extension lines
                "dimatfit": 3,          # Fit options: move text, then arrows outside
                "dimtmove": 0,          # Keep text on dimension line
                "dimdle": 0,            # No dimension line extension past arrows
            },
        )
        doc.dimstyles.set_active("Standard")

    min_x, min_y, max_x, max_y = bounding_box
    offset = 15

    unique_x_coords = []
    unique_y_coords = []

    if holes:
        unique_x_coords = sorted(list(set([h['x'] for h in holes])))
        unique_y_coords = sorted(list(set([h['y'] for h in holes])))

    panel_width = max_x - min_x
    panel_height = max_y - min_y

    """
    # Calculate dimension lines
    if panel_width / panel_height > 1.5:
        # Horizontal panel
        x_dims_from_left = [x for x in unique_x_coords if x - min_x <= panel_width / 2] + [max_x]
        x_dims_from_right = [x for x in unique_x_coords if x - min_x > panel_width / 2]
        y_dims_from_bottom = unique_y_coords + [max_y]
        y_dims_from_top = y_dims_from_bottom
    elif panel_height / panel_width > 1.5:
        # Vertical panel
        x_dims_from_left = unique_x_coords + [max_x]
        x_dims_from_right = x_dims_from_left
        y_dims_from_bottom = [y for y in unique_y_coords if y - min_y <= panel_height / 2] + [max_y]
        y_dims_from_top = [y for y in unique_y_coords if y - min_y > panel_height / 2]
    else:
        x_dims_from_left = [x for x in unique_x_coords if x - min_x <= panel_width / 2] + [max_x]
        x_dims_from_right = [x for x in unique_x_coords if x - min_x > panel_width / 2]
        y_dims_from_bottom = [y for y in unique_y_coords if y - min_y <= panel_height / 2] + [max_y]
        y_dims_from_top = [y for y in unique_y_coords if y - min_y > panel_height / 2]
    """

    # Calculate dimension lines -- show them all on all sides
    x_dims_from_left = unique_x_coords + [max_x]
    x_dims_from_right = x_dims_from_left
    y_dims_from_bottom = unique_y_coords + [max_y]
    y_dims_from_top = y_dims_from_bottom

    # X dimensions from left edge (below panel)
    dim_offset = offset + 10
    for x_coord in x_dims_from_left:
        dim = msp.add_linear_dim(
            base=(x_coord, min_y - dim_offset), 
            p1=(min_x, min_y), 
            p2=(x_coord, min_y),
            dxfattribs={"layer": "DIMENSION", "dimstyle": "Standard"}
        )
        dim.render()
        dim_offset += 12  # Increased spacing between dimension lines

    # X dimensions from right edge (above panel)
    dim_offset = offset + 10
    for x_coord in sorted(x_dims_from_right, reverse=True):
        dim = msp.add_linear_dim(
            base=(x_coord, max_y + dim_offset), 
            p1=(max_x, max_y), 
            p2=(x_coord, max_y),
            dxfattribs={"layer": "DIMENSION", "dimstyle": "Standard"}
        )
        dim.render()
        dim_offset += 12  # Increased spacing between dimension lines

    # Y dimensions from bottom edge (left of panel)
    dim_offset = offset + 10
    for y_coord in y_dims_from_bottom:
        dim = msp.add_linear_dim(
            base=(min_x - dim_offset, y_coord), 
            p1=(min_x, min_y), 
            p2=(min_x, y_coord),
            angle=90, 
            dxfattribs={"layer": "DIMENSION", "dimstyle": "Standard"}
        )
        dim.render()
        dim_offset += 12  # Increased spacing between dimension lines

    # Y dimensions from top edge (right of panel)
    dim_offset = offset + 10
    for y_coord in sorted(y_dims_from_top, reverse=True):
        dim = msp.add_linear_dim(
            base=(max_x + dim_offset, y_coord), 
            p1=(max_x, max_y), 
            p2=(max_x, y_coord),
            angle=90, 
            dxfattribs={"layer": "DIMENSION", "dimstyle": "Standard"}
        )
        dim.render()
        dim_offset += 12  # Increased spacing between dimension lines


def add_legend(msp):
    """Add a legend to the DXF file."""
    # Calculate the bounding box of the existing entities
    min_x, min_y, max_x, max_y = calculate_bounding_box(msp)
    
    # Place legend below the drawing
    legend_x = min_x
    legend_y = min_y - 20  # Place legend 20 units below the drawing
    
    # If no entities were found, place legend at origin
    if min_x == max_x == min_y == max_y == 0:
        legend_x = 0
        legend_y = 0

    legend_text = [
        "Legend:",
        "- CUT layer (red): Panel outline",
        "- DRILL layer (blue): Holes to be drilled",
        "- DIMENSION layer (green): Panel and hole dimensions",
        "- ANNOTATION layer (magenta): Hole dimensions (d=diameter, h=depth).",
        "- For side-drilled holes, Z-coordinate is included (e.g., d10 h20 z9.5).",
        "- Side-drilled holes are also marked with a blue cross on the DRILL layer."
    ]

    for i, text in enumerate(legend_text):
        msp.add_text(
            text,
            dxfattribs={
                'layer': 'ANNOTATION',
                'height': 5,
                'insert': (legend_x, legend_y - i * 10)
            }
        )


def split_layers(input_file, output_file):
    doc = ezdxf.readfile(input_file)
    
    # Check DXF version and create a new R2000 document if needed
    if doc.dxfversion < 'AC1015':  # R2000 is AC1015
        print(f"Converting from DXF version {doc.dxfversion} to R2000 for LWPOLYLINE support")
        # Create a new R2000 document
        new_doc = ezdxf.new('R2000')
        
        # Copy entities from old document to new document
        old_msp = doc.modelspace()
        new_msp = new_doc.modelspace()
        
        # We'll use the new document from here on
        doc = new_doc
        msp = new_msp
        
        # Copy entities to the new document (we'll process them in the main loop)
        original_entities = list(old_msp)
    else:
        msp = doc.modelspace()
        original_entities = list(msp)
        # Clear existing entities
        entities_to_delete = list(msp)
        for entity in entities_to_delete:
            msp.delete_entity(entity)
    
    # Create layers with proper visibility settings
    layers = doc.layers
    
    # Create CUT layer (red, visible, continuous line)
    if "CUT" not in layers:
        cut_layer = layers.new("CUT")
        cut_layer.dxf.color = 1  # Red
        cut_layer.dxf.linetype = "CONTINUOUS"
        cut_layer.on = True
        cut_layer.freeze = False
        cut_layer.lock = False
    
    # Create DRILL layer (blue, visible, continuous line)
    if "DRILL" not in layers:
        drill_layer = layers.new("DRILL")
        drill_layer.dxf.color = 5  # Blue
        drill_layer.dxf.linetype = "CONTINUOUS"
        drill_layer.on = True
        drill_layer.freeze = False
        drill_layer.lock = False

    if "DIMENSION" not in layers:
        dimension_layer = layers.new("DIMENSION")
        dimension_layer.dxf.color = 3  # Green
        dimension_layer.dxf.linetype = "CONTINUOUS"
        dimension_layer.on = True
        dimension_layer.freeze = False
        dimension_layer.lock = False

    # Create ANNOTATION layer (magenta, visible, continuous line)
    if "ANNOTATION" not in layers:
        annotation_layer = layers.new("ANNOTATION")
        annotation_layer.dxf.color = 6  # Magenta
        annotation_layer.dxf.linetype = "CONTINUOUS"
        annotation_layer.on = True
        annotation_layer.freeze = False
        annotation_layer.lock = False
    
    # Ensure CONTINUOUS linetype exists
    if "CONTINUOUS" not in doc.linetypes:
        doc.linetypes.new("CONTINUOUS")

    # Add hole annotations from CSV file
    annotations_added, holes = add_hole_annotations_from_csv(msp, input_file)
    
    allowed = {"LWPOLYLINE", "POLYLINE", "LINE", "ARC", "CIRCLE", "TEXT", "MTEXT"}
    print(f"Processing file: {input_file}")
    
    # Step 1: Collect entities and extract their data
    entity_specs = []
    for e in original_entities:
        dtype = e.dxftype()
        print(f" - Found entity: {dtype}")
        
        # FAIL EARLY: Don't skip unexpected entity types
        if dtype not in allowed:
            raise ValueError(f"Unexpected entity type: {dtype}. Only {allowed} are supported.")
        
        # Determine target layer
        if dtype == "CIRCLE":
            target_layer = "DRILL"
        elif dtype in ["LWPOLYLINE", "POLYLINE"]:
            if is_small_slot(e):
                target_layer = "DRILL"
            else:
                target_layer = "CUT"
        elif dtype in ["TEXT", "MTEXT"]:
            target_layer = "ANNOTATION"
        else:  # LINE or ARC
            target_layer = "CUT"
        
        # Extract entity data before deletion
        data = extract_entity_data(e)
        entity_specs.append((data, target_layer, dtype))
    
    # Step 2: Entities are already cleared or we're using a new document
    
    # Step 3: Create new entities with correct layers
    entities_created = 0
    for data, target_layer, dtype in entity_specs:
        try:
            new_entity = create_new_entity(msp, data, target_layer)
            print(f" - Created {dtype} on {target_layer} layer")
            entities_created += 1
        except Exception as ex:
            raise RuntimeError(f"Failed to create {dtype} entity on {target_layer} layer: {ex}")
    
    print(f"Created {entities_created} entities")
    
    # Add hole table
    min_x, min_y, max_x, max_y = calculate_bounding_box(msp)
    table_pos = (max_x + 20, max_y)
    table_entities_added = add_hole_table(msp, holes, table_pos)
    
    # Verify entities were created
    cut_count = sum(1 for e in msp if hasattr(e.dxf, 'layer') and e.dxf.layer == "CUT")
    drill_count = sum(1 for e in msp if hasattr(e.dxf, 'layer') and e.dxf.layer == "DRILL")
    annotation_count = sum(1 for e in msp if hasattr(e.dxf, 'layer') and e.dxf.layer == "ANNOTATION")
    
    print(f"Entities on CUT layer: {cut_count}")
    print(f"Entities on DRILL layer: {drill_count}")
    print(f"Entities on ANNOTATION layer: {annotation_count}")
    
    # Debug: Check entities before saving
    print("Before saving - checking entities:")
    remaining_entities = list(msp)
    print(f"  Total entities in modelspace: {len(remaining_entities)}")
    
    for e in remaining_entities:
        print(f"  Entity {e.dxftype()}: layer='{e.dxf.layer}', handle='{e.dxf.handle}'")

    # Add dimensions
    min_x, min_y, max_x, max_y = calculate_bounding_box(msp)
    add_dimensions(msp, holes, (min_x, min_y, max_x, max_y), doc)

    # Add legend
    add_legend(msp)
    
    # Save the file
    try:
        doc.saveas(output_file)
    except Exception as e:
        raise RuntimeError(f"Failed to save file: {e}")
    
    # FAIL EARLY: Verify the saved file
    try:
        verify_doc = ezdxf.readfile(output_file)
        verify_msp = verify_doc.modelspace()
        
        saved_entities = list(verify_msp)
        total_entities = len(saved_entities)
        
        print("After saving - entities found:")
        for e in saved_entities:
            print(f"  Entity {e.dxftype()}: layer='{e.dxf.layer}', handle='{e.dxf.handle}'")
        
        # Verify layers exist in saved file
        for layer_name in ["CUT", "DRILL", "ANNOTATION", "DIMENSION"]:
            if layer_name not in verify_doc.layers:
                raise RuntimeError(f"Layer {layer_name} missing from saved file")
        
        print(f"Verification: Saved file contains {total_entities} entities")
        
    except ezdxf.DXFError as e:
        raise RuntimeError(f"Saved file verification failed - DXF error: {e}")
    except Exception as e:
        raise RuntimeError(f"Saved file verification failed: {e}")
    
    print(f"Layered DXF saved as {output_file}")


def main():
    if len(sys.argv) != 3:
        print("Usage: python split_layers.py input.dxf output.dxf")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    
    # Let all exceptions propagate - fail early and clearly
    split_layers(input_file, output_file)

if __name__ == "__main__":
    main()