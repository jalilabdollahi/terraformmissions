# Walkthrough: Shaft A Becomes North

1. **Plan.** You will see four lines like
   `module.shaft_a.random_id.tag will be destroyed` and `module.north_shaft.random_id.tag will be created`
   (same for the placard file).
2. **See why.** The module's instance key is part of every address inside it. Renaming the call
   changes `module.shaft_a.*` into `module.north_shaft.*` for everything in one go.
3. **One block for the whole module.**
   ```hcl
   moved {
     from = module.shaft_a
     to   = module.north_shaft
   }
   ```
   You do not need a block per resource.
4. **Plan again.** `module.shaft_a has moved to module.north_shaft`, zero to add or destroy.
   Apply and type `check`.
