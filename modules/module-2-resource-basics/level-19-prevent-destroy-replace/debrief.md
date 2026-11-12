# Debrief: prevent_destroy is a guard, not a decision

`lifecycle { prevent_destroy = true }` makes Terraform error out on any plan that would destroy the
resource, including a **replacement**, which is a destroy followed by a create. Changing a "force new"
argument therefore trips the guard, even though nothing was explicitly deleted. The error is
the feature working: it stops you before the apply starts.

The skill here is deciding what to do next. You have three honest options:

1. revert the change that forces replacement (keep `attic`);
2. accept the replacement by removing the guard, applying, and optionally putting the guard back;
3. avoid the replacement through another route (for example a new resource, or `moved` blocks).

Here the shelf label is disposable, so option 2 was right, and the vault ledger kept its protection. For a
database the answer would be the opposite: you would change the design instead.

Two cautions. `prevent_destroy` lives in the configuration, so removing the block removes the guard for
everyone; and it does not protect against `terraform destroy` being run with the block deleted, or
against resources deleted outside Terraform. Combine it with code review rules and, for cloud
resources, provider-level deletion protection flags.
