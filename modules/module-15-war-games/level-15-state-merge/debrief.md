# Post-mortem - merging three states

**Timeline.** Tuesday: the drying team cannot plan because it depends on fields outputs that fields has not published.
Wednesday: leadership asks for a single plan across the chain. Thursday: a merged stack is written and moved against.

**Root causes.**
1. Three teams chose identical resource names. That is harmless while each state is separate, and a collision the moment
   they are merged: a merge needs unique addresses, and a module per team provides the namespace.
2. A merged configuration was hand-copied. Two numbers were wrong. Because `random_integer.min` and `max` force replacement,
   the plan would have re-rolled quotas already on paperwork.
3. A seasonal workspace hid one team's whole state behind an empty default workspace.

**How Terraform behaves.** `terraform state mv -state=SRC -state-out=DEST FROM TO` can write into another state file under
any address, including module-prefixed ones; the destination is created or appended to. A workspace is a separate state file
(`terraform.tfstate.d/<name>/`), so `terraform state list` only shows the selected one. After the move the plan is the real
check: `must be replaced` means the configuration differs on an immutable argument.

**Prevention.**
- Pick naming and ownership boundaries before merging; if two stacks use the same names, plan for a module layer.
- Merge with the plan as the oracle: expect no changes, and treat every replace as a config mistake, not a thing to apply.
- Keep a list of workspaces per stack in the runbook, and retire old code when its state is emptied.
