# Post-mortem - a hand-edited state

**Timeline.** 22:10 a migration script is run with a pre-release provider build; it renumbers instances and stamps a new schema
version. 22:40 the build is withdrawn. 23:05 the first pipeline run fails on every plan.

**Root causes.**
1. A pre-release provider wrote state, and states are not safely readable by older provider versions: each instance records the
   `schema_version` it was written with, and Terraform refuses to downgrade.
2. The script rewrote `index_key` values as integers. For `for_each` a key is part of an object's identity, so the plan sees
   old objects that are not in the configuration and new ones that are.
3. No backup of the state had been taken before running a bulk script.

**How Terraform behaves.** The state is JSON: `lineage` identifies the history, `serial` increments with each change and
decides which copy wins, and each resource instance records its `schema_version`, `index_key` and `attributes`. If the version
is higher than the provider knows, Terraform stops before any command can run, so the standard `terraform state` commands are
unavailable; only direct editing of the file is left. Direct editing is the last resort: take a backup, change as little as
possible, keep the lineage, bump the serial and prove the result with a plan that shows no changes. When the values of several
instances are interchangeable (random IDs), the mapping must come from evidence outside the state, such as a rendered output
file.

**Prevention.**
- Never run bulk state scripts without `terraform state pull > backup.json`; use `state mv` where it exists.
- Pin provider versions and keep pre-release builds out of environments that share a state.
- Prefer a remote backend with versioning, so "restore the previous revision" is always an option.
