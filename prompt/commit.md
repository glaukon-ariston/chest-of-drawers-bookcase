feat(dxf): Improve legend placement and font size

This commit improves the layout of the generated DXF files by moving the legend below the "Hole Schedule" table and aligning the font sizes for better readability.

- The legend is now positioned directly below the "Hole Schedule" table.
- The font size of the legend text now matches the font size of the table content.
- The "Legend" title font size is now the same as the "Hole Schedule" title font size.

**File Changes:**

*   `split_layers.py`:
    *   Modified `add_hole_table` to return the y-coordinate of the bottom of the table.
    *   Modified `add_legend` to accept a position argument and adjusted font sizes for the title and items.
    *   Updated the `split_layers` function to orchestrate the new placement logic.
*   `prompt/model-v2.md`, `GEMINI.md`, `README.md`:
    *   Updated with a new changelog entry for v19.
*   `artifacts/conversation.md`:
    *   Updated with a summary of the recent conversation.