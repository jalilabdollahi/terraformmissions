# Post-mortem - the module-tree refactor

**Timeline.** PR #88 merges on Monday after review of the `.tf` diff alone. Tuesday's pipeline plans a full rebuild. The release
is held; the refactor is finished with explicit moves.

**Root causes.**
1. The PR changed addresses (flat to module, count to for_each, a renamed module and resource, a changed resource type) and
   described none of them.
2. Reviewers read configuration, not the plan, so nobody saw "N to destroy" until the pipeline did.
3. A scratch resource was dropped from the code without deciding what should happen to the real object.

**How Terraform behaves.** State is a map from address to real object. `moved` blocks rewrite that map during plan, including
moves into and between modules, `count` index to `for_each` key, and a supported type change such as `null_resource` to
`terraform_data`, which keeps the ID. Moves chain, so `module.paint` can become `module.finishes` while a resource inside it is also
renamed. A `removed` block with `destroy = false` is the declarative way to stop managing something while leaving it alone;
without that setting Terraform destroys it. None of these validate what you map: random values are interchangeable to Terraform,
so only the evidence (a rendered sheet) shows that index 0 was `h2`.

**Prevention.**
- Make "no destroy for refactor PRs" a pipeline gate and show the plan summary in the review.
- Ship `moved` and `removed` blocks in the same PR as the restructure and keep them for at least one release cycle.
- Record index-to-name tables before converting `count`, and always decide explicitly what happens to retired objects.
