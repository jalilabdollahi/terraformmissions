# Walkthrough — Orchard Marionette Programme

1. `terraform plan`: `Unsupported attribute ... This object does not have an attribute named
   "puppeteer".` on `var.cast[*].puppeteer`.
2. Compare in `terraform console` (use a quick local to hold the data, or inline it):
   ```
   > [{n="x"}][*].n                       # ["x"]       list: works
   > {a={n="x"}}[*].n                     # error       map: splat wraps the map itself
   > values({a={n="x"}})[*].n             # ["x"]
   > [for k, v in {a={n="x"}} : v.n]      # ["x"]
   ```
3. Fix the two cast expressions: a `for` expression for the puppeteers and `values(var.cast)[*].strings`
   for the total. Leave `var.crew[*].name` and `var.understudy[*].name` alone; the latter is the
   idiomatic way to turn an optional (nullable) object into a list of zero or one items.
4. Apply and run `check`.
