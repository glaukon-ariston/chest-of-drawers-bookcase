feat(template): Improve CorpusShelfTemplate for sequential drilling

Increases the longest side of the `CorpusShelfTemplate` by `melanine_thickness_main` to facilitate sequential placement for drilling shelf holes in the corpus side, for each successive shelf. The dimension that is currently `bookcase_shelf_gap` is increased by `melanine_thickness_main`. The locations for the holes for the shelf have been adjusted to remain `melanine_thickness_main/2` from the edge.

The following changes were made:
- **`model.scad`**:
  - Modified `corpus_shelf_template_cut` to increase its height by `melanine_thickness_main`.
  - Updated the corresponding `generate_cut_list` entry to reflect the new dimensions.
  - Adjusted the z-coordinate of the holes in `corpus_shelf_template_drill` and `corpus_shelf_template_hole_metadata` to maintain their correct distance from the edge.
- **Documentation**:
  - Updated changelogs in `README.md`, `GEMINI.md`, and `prompt/model-v2.md` to reflect the changes.