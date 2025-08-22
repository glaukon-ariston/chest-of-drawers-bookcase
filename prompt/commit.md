feat: Refactor hole metadata and DXF export workflow

Refactored the OpenSCAD model to simplify hole metadata generation and improve the DXF export process.

- Updated `*_metadata()` functions in `model.scad` to dynamically use `export_panel_name`, enhancing code reusability.
- Removed all in-model `*_annotations()` modules and related code from `model.scad`, as annotations are now handled externally by `split_layers.py`, improving OpenSCAD export performance.
- Addressed several issues in `split_layers.py`, including:
    - Corrected entity counting logic during DXF layering.
    - Resolved `AttributeError` related to `get_extents` by using `ezdxf.bbox.extents`.
    - Fixed `UnicodeEncodeError` by removing problematic characters from success messages.
- Streamlined the DXF processing script logging:
    - Introduced `run-split-layers.ps1` to orchestrate the DXF layering process.
    - Implemented `Tee-Object` for simultaneous console output and log file recording.
    - Replaced `Write-Host` with `Write-Output` in `split-layers-dxf.ps1` to ensure comprehensive logging.
