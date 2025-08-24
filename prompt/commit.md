feat: Add DXF to DWG conversion and enhance DXF annotations

This commit introduces the following new features and improvements:

- **DXF to DWG Conversion:** Implemented automatic conversion of layered DXF files to DWG format using the ODA File Converter in batch mode. This ensures a silent and efficient conversion process, with output DWG files saved in a dedicated directory.
- **Enhanced DXF Annotations:** Updated the annotation legend in `split_layers.py` to provide clearer information about side-drilled holes. The legend now specifies that Z-coordinates are included in annotations for side-drilled holes (e.g., `d10 h20 z5`) and that a blue cross symbol marks their (X,Y) location on the DRILL layer.
- **Documentation Updates:**
    - `prompt/model-v2.md`: Updated to include details on the new DXF to DWG conversion workflow and enhanced annotation features.
    - `GEMINI.md`: Added a new changelog entry (v6) for the DXF to DWG conversion.
    - `README.md`: Updated the CNC Export section to briefly mention the DXF to DWG conversion and enhanced annotations.