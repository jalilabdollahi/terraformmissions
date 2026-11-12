# Debrief: string comparisons fail silently

`terraform.workspace == "prd"` is a legitimate boolean expression. It evaluates to `false` in every
workspace that is not literally named `prd`, which includes the one it was supposed to catch. Terraform has
no list of valid workspace names to compare against, so it cannot warn that `"prd"` will never match.

That is the fragility of workspace-driven logic. The names live in two places that nothing connects: the
CLI (`workspace new prod`) and the code (`== "prod"`). A typo in either one produces behaviour that is
valid but wrong. And the failure is dangerous in an uncomfortable direction: the *safe* branch is the
default, so a broken prod check looks like a quiet success until something needs the pager.

Ways to make this harder to get wrong:

- define the known names once, e.g. `locals { prod_workspace = "prod" }` and reuse the local;
- keep the number of environment-dependent branches small, and put them in one locals block;
- add a test or validator that runs the config in each workspace and asserts the result;
- prefer maps keyed by workspace (a later mission) over chains of `==` comparisons, since a missing key
  produces a loud error instead of a silent default.

**When workspaces are the wrong tool:** if production has behaviour that differs in *kind* (a pager, extra
resources, different retention), it deserves an explicit, reviewed input such as `var.environment` set by
the pipeline, not an inference from a name typed on someone's laptop.
