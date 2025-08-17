'''
https://claude.ai/chat/361d017e-9fb3-487b-bf1a-298aa634a54f
The key issues we resolved were:

Iterator invalidation - Fixed by collecting entity data before modifying anything
Entity corruption - Solved by creating new entities instead of modifying existing ones
DXF version compatibility - Resolved by upgrading old DXF files to R2000 format to support LWPOLYLINE entities
Layer visibility - Fixed by properly setting layer properties (color, visibility, etc.)

The final approach creates a clean separation between:

Data extraction from original entities
Document preparation (version upgrade if needed)
New entity creation with proper layer assignments

This should now work reliably with your DXF files and display properly in LibreCAD 
with entities correctly assigned to CUT and DRILL layers. The script will fail early 
if it encounters any unexpected conditions, making debugging much easier if issues 
arise with other files.
'''
import ezdxf
import sys

# Threshold for slot detection (in DXF units, e.g., mm)
SLOT_MAX_SIZE = 10.0

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
    else:
        raise ValueError(f"Unsupported entity type for creation: {dtype}")
    
    # Set the target layer
    new_entity.dxf.layer = target_layer
    
    # Copy other attributes
    if 'color' in data and data['color'] != 256:  # Not BYLAYER
        new_entity.dxf.color = data['color']
    
    return new_entity

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
    
    # Ensure CONTINUOUS linetype exists
    if "CONTINUOUS" not in doc.linetypes:
        doc.linetypes.new("CONTINUOUS")
    
    allowed = {"LWPOLYLINE", "POLYLINE", "LINE", "ARC", "CIRCLE"}
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
    
    # Verify entities were created
    cut_count = sum(1 for e in msp if hasattr(e.dxf, 'layer') and e.dxf.layer == "CUT")
    drill_count = sum(1 for e in msp if hasattr(e.dxf, 'layer') and e.dxf.layer == "DRILL")
    
    print(f"Entities on CUT layer: {cut_count}")
    print(f"Entities on DRILL layer: {drill_count}")
    
    # FAIL EARLY: Verify all entities were properly created
    if cut_count + drill_count != entities_created:
        raise RuntimeError(f"Entity creation failed: created {entities_created} but only {cut_count + drill_count} were assigned to layers")
    
    # Debug: Check entities before saving
    print("Before saving - checking entities:")
    remaining_entities = list(msp)
    print(f"  Total entities in modelspace: {len(remaining_entities)}")
    
    for e in remaining_entities:
        print(f"  Entity {e.dxftype()}: layer='{e.dxf.layer}', handle='{e.dxf.handle}'")
    
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
        
        if total_entities != entities_created:
            # Additional debugging
            all_doc_entities = []
            for layout in verify_doc.layouts:
                layout_entities = list(layout)
                print(f"Layout '{layout.dxf.name}': {len(layout_entities)} entities")
                all_doc_entities.extend(layout_entities)
            
            raise RuntimeError(f"File save verification failed: expected {entities_created} entities, found {total_entities}. Total entities in all layouts: {len(all_doc_entities)}")
        
        # Verify layers exist in saved file
        for layer_name in ["CUT", "DRILL"]:
            if layer_name not in verify_doc.layers:
                raise RuntimeError(f"Layer {layer_name} missing from saved file")
        
        print(f"Verification: Saved file contains {total_entities} entities")
        
    except ezdxf.DXFError as e:
        raise RuntimeError(f"Saved file verification failed - DXF error: {e}")
    except Exception as e:
        raise RuntimeError(f"Saved file verification failed: {e}")
    
    print(f"✅ Layered DXF saved as {output_file}")

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