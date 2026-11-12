# Post-mortem - the gauge census

**Timeline.** T-36h a storm warning triggers a push to generate duty rotas from Terraform. The first draft, which
declared a resource per register row, plans 17 new objects. The pipeline is stopped at review.

**Root causes.**
1. Configuration was written as if the infrastructure did not exist. A resource block describes what Terraform will
   create unless state already knows it, so adopting existing assets is two steps: describe, then import.
2. The register mixes active and retired stations, and the first config treated them alike.
3. `random_id.byte_length` forces replacement. Importing a value does not reconcile that argument; the config must match
   what the imported id decodes to, or the plan shows a replacement right after the import.

**How Terraform behaves.** `import` blocks (Terraform 1.5+) are declarative: they run during plan, show up as
"will be imported", and can use `for_each` since 1.7, so a whole fleet can be adopted from one data file. The ID format is
resource specific: for random_id it is the base64url value. After import, a plan that shows `-/+` on an imported object means
the configuration disagrees with the real object on a ForceNew argument.

**Prevention.**
- Adopt in bulk from a source of truth (export, inventory, CSV) rather than retyping IDs; add a validation that no ID
  appears literally in the code.
- Always read the import plan: expect 'imported' lines and nothing replaced.
- Remove import blocks only after every environment has applied them.
