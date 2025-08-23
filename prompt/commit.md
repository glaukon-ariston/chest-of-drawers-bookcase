feat(dxf): Add dimension layer and optimize layout

This commit introduces a new `DIMENSION` layer to the DXF export, providing detailed dimensions for panels and holes.

The dimensioning logic in `split_layers.py` has been significantly improved to enhance clarity and readability:
- Dimensions are now grouped and placed on the closest side of the panel to avoid crossing lines.
- The script automatically uses unique coordinates to prevent duplicate dimensions.
- Overall panel dimensions are drawn last to avoid interference with hole dimensions.
- Dimension text is now placed above the dimension line with a background fill, ensuring it is not crossed by the line.

The project documentation (`README.md`, `GEMINI.md`, `prompt/model-v2.md`) has been updated to reflect these new features.