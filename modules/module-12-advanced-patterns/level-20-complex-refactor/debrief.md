# Debrief: a refactor is a sentence Terraform has to be told

Every change in this level is harmless to the real world, and each one looks like a destroy to Terraform because it
compares addresses. Moving from `count` to `for_each` changes `x[0]` into `x["name"]`. Removing a block from the code
means "destroy the object". A new resource block means "create one". Terraform has three declarative tools that
turn each of these into the correct sentence, and they all work in the plan, before anything changes:

- **`moved`** says "this object now lives at that address". One block per instance when the key changes shape.
- **`removed`** with `destroy = false` says "stop managing this and leave it alone"; with `destroy = true` it is the
  tool for decommissioning with destroy-time provisioners.
- **`import`** says "this existing object is the one for this resource block".

The workflow for large refactors is always the same. First write the code you want. Run a plan and read it as a diff of
intentions: every destroy or create is a missing sentence. Add the blocks until the summary reads 0 to destroy, zero to
replace. Only then apply. The blocks can be deleted after every environment has applied them.

This is also why teams review the plan, not just the code. A reviewer who sees six `has moved to` lines and
one `will no longer be managed` line knows exactly what the commit does to production.

Real-world takeaway: large state migrations should be expressible entirely as moved, removed and import blocks in one
reviewable pull request, with a plan that proves zero destroys. Reach for `terraform state` commands only when that is not possible.
