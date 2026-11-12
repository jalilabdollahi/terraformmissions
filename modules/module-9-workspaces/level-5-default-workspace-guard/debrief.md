# Debrief: warnings do not stop applies

Terraform gives you several places to assert things, and they differ in what happens when the assertion
fails:

| Construct | On failure |
|---|---|
| `check` block with `assert` | warning only, run continues |
| resource/data/output `precondition` | error, plan or apply stops before the object changes |
| `postcondition` | error after the object is read or created |
| variable `validation` | error when the input value is wrong |

The original author reached for `check` because it reads naturally ("check that we are not in default"),
and testing showed a message appearing. The message appearing is exactly the problem: the warning is
scrolling past in a CI log and the apply that followed it created real objects in a workspace nobody is
meant to use.

A guard against `default` is a sensible habit when a team uses named workspaces. The default workspace
always exists and cannot be deleted, so it is where a forgotten `terraform workspace select` leaves you. The
precondition turns a silent mistake into an immediate, explained failure.

Attach the guard to the resource or output that would be the first casualty. If you have many resources,
a single `terraform_data` guard resource that others `depends_on` keeps it in one place.

**When workspaces are the wrong tool:** a guard that has to exist because the CLI can land in the wrong
context is a sign the context is too easy to get wrong. If a wrong workspace could cause real damage, move
environments into separate directories with separate state backends and credentials.
