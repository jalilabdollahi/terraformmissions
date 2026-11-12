# Walkthrough — Cider Press Vintage

1. **Run apply and look at the result.** There is no error, only `cider/applewick-unknown.txt`
   with "vintage unknown". A default hid the broken wiring.
2. **Trace the value.** `main.tf` passes `vintage = var.vintage` to the press. `modules/press/main.tf` declares
   `variable "vintage"` but its call to the bottler passes only `orchard`.
3. **Add the missing hop** in `modules/press/main.tf`: `vintage = var.vintage` inside `module "bottler"`.
4. Apply. The old "unknown" file disappears because the file name changed. Then `check`.
