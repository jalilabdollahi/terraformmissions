# Walkthrough — Kayak Club Rota

1. **First error.** `Unsupported attribute ... This object does not have an attribute named
   "state"`. In `club/fleet.json` the field is `status`. Fix the condition: `if boat.status == "serviceable"`.
2. **Second error.** `Duplicate object key ... Two different items produced the key "river"`. A
   `for` expression that builds an object needs unique keys. Because boats share a class, use
   grouping mode (`...`) after the value expression:
   ```hcl
   ready_by_class = { for boat in local.fleet : boat.class => boat.id... if boat.status == "serviceable" }
   ```
   Each key now maps to a list of ids.
3. `terraform apply`. `terraform output ready_by_class` shows `river = ["K-01","K-04"]` and
   `sea = ["K-02","K-05"]`; `surf` is absent because its only boat is retired. Type `check`.
