# Post-mortem — Halden Hall B Teardown

**Timeline.** 23:38 the Sunday teardown started; s1 was returned at 23:40. 23:41 the runner was killed during s2, leaving
`crates/manifest.lock`. 23:50 someone used `state rm` on stand s3 "to unblock", leaving its signage file orphaned.
06:00 on-call found a floor plan that would not render, a destroy that could not run, and a half-empty hall.

**Root causes.**
1. A lock protocol with no staleness handling: killed processes leave locks forever.
2. A root output referencing `module.hall_b[0]` made the whole configuration unplannable the moment the hall was
   switched off, so the teardown itself was impossible.
3. `terraform state rm` removes tracking, not the object. Terraform can no longer delete what it no longer knows.
4. Destroy-time provisioners run only while their resource is still in configuration. Deleting the module call
   instead of switching it off would have skipped the handover entirely.

**Lessons.** An interrupted destroy has three layers: what Terraform still tracks, what exists on disk, and what
the process left behind (locks). Finish them in that order, verifying each assumption (is the pid alive?) before
removing it. Destroy-time side effects are part of the contract; proving they happened is better than assuming.

**Prevention.**
- Use `try()` or `one()` for references into optional modules.
- Write locks with a pid and check liveness before refusing.
- Prefer `removed` blocks over ad hoc `state rm`, and clean files when you stop tracking them.
- Keep an operations log (here `unrig.log`) that proves the side effect.
