# Debrief: settings files keyed by workspace

Putting per-environment settings in `env/<workspace>.yaml` and loading them with
`yamldecode(file("env/${terraform.workspace}.yaml"))` is a tidy pattern. The configuration stays the same
for every environment, and settings are plain data reviewed in pull requests, diffed easily and editable by
people who do not write HCL.

Two details cause nearly all the trouble. `file()` only reads **text**: you must decode it with `yamldecode`
or `jsondecode` before using attributes. And the file name is a *contract with a workspace name*, because
the lookup is plain string concatenation. `production.yaml` is a perfectly reasonable file name and a
perfectly wrong one: Terraform does not search for something close, it fails with the exact path it tried.

Reading the exact path in the error message is the fastest diagnostic. Terraform shows the path that
`terraform.workspace` produced, which tells you what the workspace is *really* called.

Improvements worth considering: `fileexists()` plus a fallback to `env/default.yaml` for throwaway
workspaces, schema checks on the decoded object (a variable with a type constraint, or preconditions), and
keeping secrets out of these files, because they are committed to version control.

**When workspaces are the wrong tool:** if the environments differ in more than values, say in regions,
accounts or credentials, one workspace cannot carry that. In that case use `-var-file=env/prod.tfvars`
with a separate backend per environment, so the choice of settings and the choice of state cannot drift
apart.
