# Debrief: delete means destroy, then forget

`terraform workspace delete` removes the workspace's *state*. It does not remove real things. That is why
Terraform refuses when the state still tracks resources: deleting it would forget those resources while they
carry on existing in the real world, still costing money or occupying names, and nothing would be left that
knows how to clean them up. The refusal is a safety net, not an obstacle.

The proper retirement order is always the same: select the workspace, `terraform destroy` (review the plan,
because you are destroying in the right workspace only if `terraform workspace show` says so), switch
away, then delete. You cannot delete the workspace you are standing in, and the `default` workspace cannot be
deleted at all.

`terraform workspace delete -force` exists for state that is already worthless, for example when the real
resources were removed by other means. Using it on live resources creates orphans that the validator here
detects: the file is still on disk and nothing owns it.

Before destroying, double check the context. The classic disaster is a destroy run in the wrong workspace.
Reading the plan's resource names is not enough because both workspaces use the same addresses; the
workspace name is the difference.

**When workspaces are the wrong tool:** short-lived experiments like this one fit workspaces well. Long-lived
environments are different: nobody should be one `workspace delete` away from a missing production state.
Use separate state backends with different access rights for anything that matters.
