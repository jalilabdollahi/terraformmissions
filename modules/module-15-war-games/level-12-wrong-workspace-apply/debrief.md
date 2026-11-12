# Post-mortem - posts built in the wrong workspace

**Timeline.** 01:40 an engineer debugging a prod-only radio issue pins `env = "prod"` in the config and applies it with
`staging` selected. 02:05 race control sees duplicate post cards. 02:20 the state mismatch is identified.

**Root causes.**
1. A literal in `locals` replaced the workspace-derived environment. The same config therefore produced prod resources
   anywhere it ran.
2. The terminal prompt did not show the active workspace, and the pipeline allowed manual applies from laptops.
3. Staging and prod share one codebase; the only thing that separates them is which state file Terraform opens.

**How Terraform behaves.** A workspace is nothing more than another state file selected by name. With the local backend
it lives at `terraform.tfstate.d/<workspace>/terraform.tfstate`; remote backends store one object per workspace. Resource
addresses carry no environment, so a resource created in the wrong state belongs, as far as Terraform knows, to that
workspace. Moving it needs `terraform state mv -state=... -state-out=...`; `state pull` and `state push` would replace
a whole workspace and lose the target's own resources.

**Recovery.** Back up both files, move whole resource families, and make the configuration environment-aware again so the
next plan in each workspace is clean. Compare IDs before and after: they must be identical, because real consumers
already hold them.

**Prevention.**
- Derive environment names from `terraform.workspace` (or a required variable), never from a literal.
- Print the workspace in the shell prompt and in the first line of every CI plan.
- Require approval for applies outside the pipeline, and use per-environment credentials so a staging session cannot
  touch prod.
