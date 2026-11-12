# Walkthrough — Marionette Programme Codes

1. **Plan.** Two errors appear:
   ```
   Error: Invalid value for variable
     on main.tf line 19, in module "billing": show_code = "${var.troupe}-${var.run_no}"
     show_code must be three capital letters, a dash and two digits, e.g. MAR-07.
   ...
     doors_open_min must be between 15 and 90 minutes.
   ```
2. **Fix show_code.** The caller passes `marionette-7`. Build the code instead:
   `format("%s-%02d", upper(substr(var.troupe, 0, 3)), var.run_no)` gives `MAR-07`.
3. **Fix doors_open_min.** The caller passes `1` (an hour). The module counts minutes: `var.doors_open_hours * 60`.
4. Apply. Try `-var doors_open_hours=2`: the module rejects 120 minutes, which is exactly its job. Then `check`.
