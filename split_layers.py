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


def split_layers(input_file, output_file):
    doc = ezdxf.readfile(input_file)
    msp = doc.modelspace()

    # Ensure layers exist
    for layer in ["CUT", "DRILL"]:
        if layer not in doc.layers:
            doc.layers.new(layer)

    allowed = {"LWPOLYLINE", "POLYLINE", "LINE", "ARC", "CIRCLE"}

    for e in msp:
        dtype = e.dxftype()
        if dtype not in allowed:
            raise ValueError(f"Unexpected entity type: {dtype}")

        if dtype == "CIRCLE":
            e.dxf.layer = "DRILL"

        elif dtype in ["LWPOLYLINE", "POLYLINE"]:
            if is_small_slot(e):
                e.dxf.layer = "DRILL"
            else:
                e.dxf.layer = "CUT"

        else:  # LINE or ARC
            e.dxf.layer = "CUT"

    doc.saveas(output_file)
    print(f"✅ Layered DXF saved as {output_file}")


def main():
    if len(sys.argv) != 3:
        print("Usage: python split_layers.py input.dxf output.dxf")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    split_layers(input_file, output_file)


if __name__ == "__main__":
    main()
