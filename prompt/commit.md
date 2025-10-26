feat: Update model parameters and order generation

This commit introduces several updates to the model parameters and order generation scripts.

- **Model Parameterization:**
    - Changed `melanine_thickness_main` from 19 to 18.
    - Changed `melanine_thickness_secondary` from 12 to 10.

- **Order Generation:**
    - Updated `create_order.py` to correctly handle banding for the 'Sizekupres' service.
    - Updated material codes for the 'Elgrad' service.

- **Template Panels:**
    - Changed the material for template panels from 12mm to 18mm melanine.

- **Documentation:**
    - Updated `README.md`, `GEMINI.md`, and `prompt/model-v2.md` to reflect the changes.