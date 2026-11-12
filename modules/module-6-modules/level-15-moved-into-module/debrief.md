# Debrief — moved blocks cross module boundaries

A resource's identity in state is its full address, including the module path. When you extract resources into a
module, nothing about the real objects changes, but every address does: `random_id.ticket` becomes
`module.shed.random_id.ticket`. Without help, Terraform plans to destroy the old addresses and create the new ones.
For a random ID that means a new value; for a database, data loss.

A `moved` block tells Terraform that the object at `from` is now at `to`, and the next plan or apply updates state
before comparing. Unlike `terraform state mv` it lives in the code, goes through review, and applies automatically
for everyone who runs the configuration. A block that moves a resource *into* a module is written in the caller
(here the root), because `from` is an address relative to the module that contains the block.

Keep the block in the code until every state that might hold the old address has applied it; deleting it early
orphans anyone who has not. There is a safety net for the module's authors too: a module can contain its own `moved`
blocks for internal renames, and a module may use `moved` to rename itself (`from = module.old`, `to = module.new`).

Always read the plan before applying a refactor. The line "has moved to" is what you want to see; "will be destroyed"
for something you only reorganised is the signal to stop and add a move.

**Takeaway:** every extraction into a module needs one `moved` block per resource, written in the caller; check
with a plan that says "moved" and shows no destroy.
