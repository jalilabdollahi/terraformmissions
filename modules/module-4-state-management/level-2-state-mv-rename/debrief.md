# Debrief — addresses are identities

Terraform tracks every real object by its **resource address** (`random_pet.keeper`). When you rename
a block in code, the address changes. Terraform finds an object in state with no matching block, so
it plans a **destroy**. It finds a block with no object in state, so it plans a **create**. For a
`random_pet`, that means a brand-new codename. For a database, it could mean data loss.

`terraform state mv` changes only the address in the state file. The real object, its ID and all its
attributes stay the same. The next plan matches code to state again and reports no changes.

## When to use which tool

| Tool | Where it lives | Good for |
|---|---|---|
| `terraform state mv` | your terminal, once | quick one-off fixes, local experiments |
| `moved {}` block | the code, reviewed in a PR | shared code and modules, where every user of the config needs the same move |

In a team, a `moved` block is usually better because everyone who runs the code gets the same
migration. `state mv` is the scalpel you reach for when you own the state and need a fix now.
**Always back up before state surgery:** `terraform state pull > backup.tfstate`.
