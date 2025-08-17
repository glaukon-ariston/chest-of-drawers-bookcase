import ezdxf
import sys
import os
from collections import Counter

def analyze_dxf(filepath):
    try:
        doc = ezdxf.readfile(filepath)
    except IOError:
        print(f"Not a DXF file or a generic I/O error: {filepath}")
        return
    except ezdxf.DXFStructureError:
        print(f"Invalid or corrupted DXF file: {filepath}")
        return

    print(f"Analyzing file: {filepath}")
    msp = doc.modelspace()
    layer_count = Counter(entity.dxf.layer for entity in msp)

    print("Layers found in modelspace and number of entities on each layer:")
    for layer, count in layer_count.items():
        print(f"  - Layer: {layer}, Entities: {count}")
    print("-" * 20)

def main():
    if len(sys.argv) != 2:
        print("Usage: python analyze_dxf.py <file_or_directory>")
        sys.exit(1)

    path = sys.argv[1]

    if os.path.isfile(path):
        analyze_dxf(path)
    elif os.path.isdir(path):
        for root, _, files in os.walk(path):
            for file in files:
                if file.lower().endswith(".dxf"):
                    filepath = os.path.join(root, file)
                    analyze_dxf(filepath)
    else:
        print(f"Error: Invalid path '{path}'")
        sys.exit(1)

if __name__ == "__main__":
    main()
