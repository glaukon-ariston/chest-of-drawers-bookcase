import ezdxf
import sys
import csv
import os
import ezdxf.units
import math

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
        "name": 50,
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
                hole_name_text = hole_name
                if z != 0:
                    dimension_text = f"d{diameter} h{depth} z{z}"
                else:
                    dimension_text = f"d{diameter} h{depth}"

                # Add hole name to the ANNOTATION layer
                msp.add_text(
                    hole_name_text,
                    dxfattribs={
                        'layer': 'ANNOTATION',
                        'height': 2.5,
                        'insert': (x, y + 10)
                    }
                )
                
                # Add dimension text to the ANNOTATION layer
                msp.add_text(
                    dimension_text,
                    dxfattribs={
                        'layer': 'ANNOTATION',
                        'height': 2.5,
                        'insert': (x, y + 5)
                    }
                )
                print(f"  - Added annotation: {hole_name_text} / {dimension_text} at ({x}, {y})")
                annotations_added += 2
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


def get_entity_bounds(entity):
    """Get the bounding box of a single entity."""
    dtype = entity.dxftype()
    
    if dtype == "CIRCLE":
        cx, cy = entity.dxf.center.x, entity.dxf.center.y
        r = entity.dxf.radius
        return cx - r, cy - r, cx + r, cy + r
        
    elif dtype == "LINE":
        x1, y1 = entity.dxf.start.x, entity.dxf.start.y
        x2, y2 = entity.dxf.end.x, entity.dxf.end.y
        return min(x1, x2), min(y1, y2), max(x1, x2), max(y1, y2)
        
    elif dtype == "ARC":
        # For arcs, we need to calculate the actual bounds considering the arc sweep
        cx, cy = entity.dxf.center.x, entity.dxf.center.y
        r = entity.dxf.radius
        start_angle = math.radians(entity.dxf.start_angle)
        end_angle = math.radians(entity.dxf.end_angle)
        
        # Start with the arc endpoints
        x1 = cx + r * math.cos(start_angle)
        y1 = cy + r * math.sin(start_angle)
        x2 = cx + r * math.cos(end_angle)
        y2 = cy + r * math.sin(end_angle)
        
        min_x = min(x1, x2)
        min_y = min(y1, y2)
        max_x = max(x1, x2)
        max_y = max(y1, y2)
        
        # Check if arc crosses any axis-aligned extremes
        # Normalize angles to 0-360 range
        start_norm = start_angle % (2 * math.pi)
        end_norm = end_angle % (2 * math.pi)
        
        # Handle the case where arc crosses 0 degrees
        if start_norm > end_norm:
            end_norm += 2 * math.pi
        
        # Check for crossings of 0°, 90°, 180°, 270°
        for test_angle in [0, math.pi/2, math.pi, 3*math.pi/2]:
            if start_norm <= test_angle <= end_norm or start_norm <= test_angle + 2*math.pi <= end_norm:
                test_x = cx + r * math.cos(test_angle)
                test_y = cy + r * math.sin(test_angle)
                min_x = min(min_x, test_x)
                min_y = min(min_y, test_y)
                max_x = max(max_x, test_x)
                max_y = max(max_y, test_y)
        
        return min_x, min_y, max_x, max_y
        
    elif dtype in ["LWPOLYLINE", "POLYLINE"]:
        points = list(entity.get_points())
        if not points:
            raise ValueError(f"Polyline entity has no points")
        
        xs = [p[0] for p in points]
        ys = [p[1] for p in points]
        return min(xs), min(ys), max(xs), max(ys)
        
    elif dtype in ["TEXT", "MTEXT"]:
        # For text, we'll use the insertion point and estimate bounds
        x, y = entity.dxf.insert.x, entity.dxf.insert.y
        
        if dtype == "TEXT":
            height = entity.dxf.height
            text = entity.dxf.text
        else:  # MTEXT
            height = entity.dxf.char_height
            text = entity.dxf.text
        
        # Rough estimation: assume average character width is 0.7 * height
        width = len(str(text)) * height * 0.7
        
        return x, y, x + width, y + height
        
    elif dtype == "DIMENSION":
        # For dimension entities, try the generic bbox method first
        if hasattr(entity, 'bbox') and callable(entity.bbox):
            bbox = entity.bbox()
            if bbox and bbox.extmin and bbox.extmax:
                return bbox.extmin.x, bbox.extmin.y, bbox.extmax.x, bbox.extmax.y
        
        # Fallback: use dimension definition points if bbox is not available
        # Most dimensions have defpoint, defpoint2, etc.
        points = []
        for attr in ['defpoint', 'defpoint2', 'defpoint3', 'text_midpoint']:
            if hasattr(entity.dxf, attr):
                point = getattr(entity.dxf, attr)
                if point:
                    points.append((point.x, point.y))
        
        if points:
            xs = [p[0] for p in points]
            ys = [p[1] for p in points]
            return min(xs), min(ys), max(xs), max(ys)
        
        # If no definition points found, dimension might be empty/invalid
        raise ValueError(f"DIMENSION entity has no valid definition points")
        
    else:
        # For any other types, try the generic bbox method
        if hasattr(entity, 'bbox') and callable(entity.bbox):
            bbox = entity.bbox()
            if bbox and bbox.extmin and bbox.extmax:
                return bbox.extmin.x, bbox.extmin.y, bbox.extmax.x, bbox.extmax.y
        
        # Fail early for truly unsupported entity types
        raise ValueError(f"Unsupported entity type for bounding box calculation: {dtype}")


def calculate_bounding_box(msp, layer_filter=None):
    """Calculate the bounding box of entities in modelspace, optionally filtered by layer."""
    min_x = min_y = float('inf')
    max_x = max_y = float('-inf')
    entity_count = 0
    
    for entity in msp:
        # Apply layer filter if specified
        if layer_filter is not None:
            if not hasattr(entity.dxf, 'layer') or entity.dxf.layer not in layer_filter:
                continue
        
        bounds = get_entity_bounds(entity)
        if bounds and len(bounds) == 4:
            ent_min_x, ent_min_y, ent_max_x, ent_max_y = bounds
            
            # Only update if we got valid bounds (not all zeros or invalid)
            if not (ent_min_x == ent_max_x == ent_min_y == ent_max_y == 0):
                min_x = min(min_x, ent_min_x)
                min_y = min(min_y, ent_min_y)
                max_x = max(max_x, ent_max_x)
                max_y = max(max_y, ent_max_y)
                entity_count += 1
    
    if entity_count == 0 or min_x == float('inf'):
        layer_info = f" for layers {layer_filter}" if layer_filter else ""
        raise RuntimeError(f"No valid entities found for bounding box calculation{layer_info} - cannot proceed without valid geometry")
    
    layer_info = f" from layers {layer_filter}" if layer_filter else ""
    print(f"Bounding box calculated from {entity_count} entities{layer_info}: ({min_x:.2f}, {min_y:.2f}) to ({max_x:.2f}, {max_y:.2f})")
    return min_x, min_y, max_x, max_y


def add_dimensions(msp, holes, bounding_box, doc):
    """Adds dimension lines for the panel and holes, optimizing for clarity."""
    # Ensure a dimension style exists
    if "Standard" not in doc.dimstyles:
        style = doc.dimstyles.new(
            "Standard",
            dxfattribs={
                "dimtxsty": "OpenSans",
                "dimtxt": 9,          # Text height
                "dimasz": 5,          # Arrow size
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

    x_coords = []
    y_coords = []

    if holes:
        x_coords = [h['x'] for h in holes]
        y_coords = [h['y'] for h in holes]

    panel_width = max_x - min_x
    panel_height = max_y - min_y

    # Calculate dimension lines -- show them all on all sides
    x_dims_from_left = sorted(list(set([x for x in x_coords + [max_x] if x != 0])))
    x_dims_from_right = sorted(list(set([x for x in x_coords + [max_x] if x != max_x])))
    y_dims_from_bottom = sorted(list(set([y for y in y_coords + [max_y] if y != 0])))
    y_dims_from_top = sorted(list(set([y for y in y_coords + [max_y] if y != max_y])))

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
        dim_offset += 8  # Increased spacing between dimension lines

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
        dim_offset += 8  # Increased spacing between dimension lines

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
        dim_offset += 8  # Increased spacing between dimension lines

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
        dim_offset += 8  # Increased spacing between dimension lines


def add_legend(msp):
    """Add a legend to the DXF file."""
    # Calculate the bounding box of the existing entities
    min_x, min_y, max_x, max_y = calculate_bounding_box(msp)
    
    # Place legend below the drawing
    legend_x = min_x
    legend_y = min_y - 20  # Place legend 20 units below the drawing

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


def add_title(msp, panel_name, bounding_box):
    """Adds a title with the panel name to the DXF."""
    if not panel_name:
        return

    # Import the alignment enum
    from ezdxf.enums import TextEntityAlignment

    min_x, min_y, max_x, max_y = bounding_box
    
    # Position the title at the top center
    title_x = (min_x + max_x) / 2
    title_y = max_y + 20  # 20 units above the top of the panel

    # Create the text entity first, then set its placement
    title_text = msp.add_text(
        panel_name,
        dxfattribs={
            'layer': 'ANNOTATION',
            'style': 'Title',
            'height': 10,  # Larger height for the title
        }
    )
    
    # Use set_placement to properly center the text
    # MIDDLE_CENTER centers both horizontally and vertically at the insertion point
    title_text.set_placement((title_x, title_y), align=TextEntityAlignment.MIDDLE_CENTER)


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
    
    # Set units to millimeters
    doc.header['$INSUNITS'] = ezdxf.units.MM

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
    
    # Add dimensions using the CUT and DRILL layer geometry bounding box only
    geometry_bbox = calculate_bounding_box(msp, layer_filter=['CUT'])
    add_dimensions(msp, holes, geometry_bbox, doc)

    # Add legend
    add_legend(msp)
    
    # Add hole table - calculate bounding box from CUT and DRILL layers only
    min_x, min_y, max_x, max_y = calculate_bounding_box(msp)
    table_pos = (max_x + 20, max_y)
    table_entities_added = add_hole_table(msp, holes, table_pos)
    
    # Create a text style for the title
    if "Title" not in doc.styles:
        doc.styles.new("Title", dxfattribs={"font": "ISOCPEUR.ttf"})

    # Add title
    panel_name = os.path.basename(os.path.splitext(input_file)[0])
    final_bbox_before_title = calculate_bounding_box(msp)
    add_title(msp, panel_name, final_bbox_before_title)

    # Verify entities were created
    cut_count = sum(1 for e in msp if hasattr(e.dxf, 'layer') and e.dxf.layer == "CUT")
    drill_count = sum(1 for e in msp if hasattr(e.dxf, 'layer') and e.dxf.layer == "DRILL")
    annotation_count = sum(1 for e in msp if hasattr(e.dxf, 'layer') and e.dxf.layer == "ANNOTATION")
    dimension_count = sum(1 for e in msp if hasattr(e.dxf, 'layer') and e.dxf.layer == "DIMENSION")
    
    print(f"Entities on CUT layer: {cut_count}")
    print(f"Entities on DRILL layer: {drill_count}")
    print(f"Entities on ANNOTATION layer: {annotation_count}")
    print(f"Entities on DIMENSION layer: {dimension_count}")
    
    # Debug: Check entities before saving
    print("Before saving - checking entities:")
    remaining_entities = list(msp)
    print(f"  Total entities in modelspace: {len(remaining_entities)}")
    
    for e in remaining_entities:
        print(f"  Entity {e.dxftype()}: layer='{e.dxf.layer}', handle='{e.dxf.handle}'")

    # Calculate final bounding box for layout viewport
    final_min_x, final_min_y, final_max_x, final_max_y = calculate_bounding_box(msp)
    
    # Create A4 landscape layout
    layout = doc.layouts.new('A4 landscape')
    layout.page_setup(
        size=(297, 210),  # A4 landscape paper size in mm
        margins=(10, 10, 10, 10),  # 10mm margins
        units='mm'
    )

    # Add a viewport to the layout
    # The viewport is centered on the page
    # The size of the viewport is the paper size minus the margins
    viewport = layout.add_viewport(
        center=(297 / 2, 210 / 2),
        size=(297 - 20, 210 - 20),
        view_center_point=(0, 0),  # Initial view center
        view_height=100  # Initial view height
    )
    
    # Fit the viewport to the modelspace extents
    if final_min_x != final_max_x or final_min_y != final_max_y:
        # get viewport size in paper space
        vp_width = viewport.dxf.width
        vp_height = viewport.dxf.height

        # get modelspace extents
        center = ((final_min_x + final_max_x) / 2, (final_min_y + final_max_y) / 2)
        width = final_max_x - final_min_x
        height = final_max_y - final_min_y

        # set the view center
        viewport.dxf.view_center_point = center

        # calculate the view height to fit the modelspace extents
        if width == 0 or height == 0:
            view_height = 100  # default value
        elif width / height > vp_width / vp_height:
            view_height = width * vp_height / vp_width
        else:
            view_height = height
        
        # set the view height, add a 10% margin
        viewport.dxf.view_height = view_height * 1.1
    else:
        raise RuntimeError("Invalid final bounding box - cannot set viewport")

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