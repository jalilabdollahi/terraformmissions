# Walkthrough — Sugarhouse Season Label

1. **Run apply and look at the result.** There is no error, only `syrup/hollisford-unknown.txt`
   with "season unknown". A default hid the broken wiring.
2. **Trace the value.** `main.tf` passes `season = var.season` to the evaporator. `modules/evaporator/main.tf` declares
   `variable "season"` but its call to the canner passes only `sugarbush`.
3. **Add the missing hop** in `modules/evaporator/main.tf`: `season = var.season` inside `module "canner"`.
4. Apply. The old "unknown" file disappears because the file name changed. Then `check`.
