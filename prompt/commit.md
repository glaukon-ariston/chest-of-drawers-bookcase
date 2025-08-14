feat: Add exploded view feature

This commit introduces an exploded view feature to the model.

- Added `exploded_view` and `explosion_factor` parameters.
- Implemented an `explode` module to translate components away from the center.
- Updated the main assembly to use the `explode` module when `exploded_view` is enabled.
- Refactored the `explode` module to use a single vector argument for the component center.
- Updated documentation to reflect the new feature.