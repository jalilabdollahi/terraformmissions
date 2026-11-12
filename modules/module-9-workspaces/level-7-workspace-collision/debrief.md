# Debrief: state is isolated, the world is not

A workspace gives you a separate **state**. It does not give you a separate world. When two workspaces
manage a file at the same path, a bucket with the same name or a DNS record with the same label, each
believes it owns it, and each one is happily correct about its own records. Whichever applies last changes
the real object, and the other workspace sees drift on its next plan.

This is the most common workspace bug in real life. It is not limited to files: IAM roles, security groups
and databases all have names that must be unique per account. The cure is the same everywhere: every
identifier that lives outside Terraform must include something workspace-specific (the name itself, a
prefix, a directory). `terraform.workspace` is the usual source.

Two further points. First, when you rename the objects the old shared files become orphans: the next
apply in one wing destroys `out/bunks.txt` while the other wing may still think it exists there, so
migrate one workspace at a time and check each plan. Second, some resources
can't be separated by naming at all, for example things that exist only once per account or region. For
those, keep them in a separate configuration that no workspace owns.

**When workspaces are the wrong tool:** if two environments really share a few objects, workspaces
will fight over them. A dedicated "shared" root module whose outputs are read by the environment
configurations is clearer than hoping every workspace agrees about who is in charge.
