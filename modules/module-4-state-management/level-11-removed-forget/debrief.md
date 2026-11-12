# Debrief — forgetting as a reviewed code change

Handing an object over to someone else is a normal event: a team splits, a resource moves to another
repository, a database is adopted by a platform team. In all those cases you want Terraform to
*forget* the object, not delete it.

`terraform state rm` does that imperatively against one state. The `removed` block (Terraform 1.7+) does
it declaratively: the block says which address is leaving and, through `lifecycle { destroy = false }`,
that the real object must survive. It travels through version control, is reviewed like any other
change, and runs in every workspace or environment that applies the code.

The important detail is the default. A `removed` block without the lifecycle setting destroys the object
(it behaves like deleting the resource block, but explicit). That is also why validators and reviewers
look for `destroy = false` whenever an object must survive.

After the apply, the removed block is a no-op, so you can leave it for a release or two for other
environments that still hold the object in their own state, then delete it. A related lesson: a plan that
says "will no longer be managed by Terraform" is the one you want here; "will be destroyed" is the one you
want to avoid. Reading the plan text before you apply is the whole safety net.
