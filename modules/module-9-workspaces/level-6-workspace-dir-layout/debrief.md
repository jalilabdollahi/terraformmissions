# Debrief: workspaces are just directories (with the local backend)

With the local backend there is no hidden database. The default workspace keeps its state in
`terraform.tfstate` next to the code. Every other workspace gets a folder, and its state is always
`terraform.tfstate.d/<name>/terraform.tfstate`. The selected name lives in `.terraform/environment`. That is
the whole mechanism, and it explains the behaviour in this mission: a workspace is *defined by that
directory*, and a state file Terraform cannot find might as well not exist. It does not complain; it
simply plans to create everything again.

The danger is what comes next. If somebody had applied in the empty winter workspace, Terraform would have
overwritten the real files on disk and created a fresh state with a new lineage. Two states would
now describe one infrastructure. Restoring the file *before* any apply keeps the original lineage and
serial intact, which is how the validator recognised the right state.

Practical takeaways: back up the whole `terraform.tfstate.d/` folder with the code, never commit state to
Git, and when a plan suddenly wants to create everything, stop and check where the state went before
reaching for `apply`.

**When workspaces are the wrong tool:** local state per workspace, sitting in a project folder, is fine on
a laptop and a poor idea for a team. A remote backend gives locking, versions and access control, and it
makes a "dragged file" accident impossible. For environments that must be isolated from one another, use
separate backends instead of subfolders of one.
