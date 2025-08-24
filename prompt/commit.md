feat(dxf): Enhanced Hole Visualization in DXF Export

- The `split_layers.py` script now includes the Z-coordinate in the text annotations for side-drilled holes (holes where the Z-coordinate is non-zero), providing clearer manufacturing information.
- A small cross symbol is now added at the (X,Y) location of side-drilled holes on the `DRILL` layer in 2D panel projections, serving as a visual indicator to distinguish them from through-holes or face-drilled holes.
