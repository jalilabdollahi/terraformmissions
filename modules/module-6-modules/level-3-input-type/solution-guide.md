# Walkthrough — Gust Gauge Verdict

1. **Plan and read the type error.**
   ```
   Error: Invalid value for input variable
     on main.tf line 10, in module "windcheck":
   The given value is not suitable for module.windcheck.var.gusts_kmh declared at
   modules/windcheck/main.tf:5,1-27: list of number required.
   ```
2. **Spot the mismatch.** `var.gusts` is the string `"12,18,25,28"`; the module needs `[12, 18, 25, 28]`.
3. **Convert in the caller.** `gusts_kmh = split(",", var.gusts)`.
4. Apply: peak is 28, verdict `fly all kites`. Try `-var gusts="15,40"` to see `stunt kites only`. Then `check`.
