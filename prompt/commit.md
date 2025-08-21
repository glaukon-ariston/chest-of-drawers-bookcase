feat: Make hole annotation offset a vector parameter

Make the `annotation_text_offset` a vector parameter in the `hole_annotation` module. This allows for different offsets for each annotation, which is necessary to keep the annotations within the panel boundaries.

- The `annotation_text_offset` is now a vector parameter in the `hole_annotation` module.
- All calls to `hole_annotation` have been updated to use the new `text_offset` parameter.
- The rotation and position of annotations in several modules have been corrected.
- A bug where some annotations were placed outside the panel has been fixed.