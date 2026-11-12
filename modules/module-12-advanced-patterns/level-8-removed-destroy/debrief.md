# Debrief: removed blocks have two modes

Deleting a resource block normally makes Terraform destroy the object on the next apply. The
`removed` block (Terraform 1.7+) makes that intent explicit and adds control: with `destroy = false`
Terraform forgets the object but leaves it alone, and with `destroy = true` (the default) it destroys
it as if the block still existed.

The decommissioning mode has a feature that plain deletion does not: destroy-time provisioners can be
attached to the `removed` block. When you simply delete a resource block, its `provisioner ... when = destroy`
disappears with it, so cleanup steps never run. Terraform even warns about this. Placing the
provisioner inside `removed` keeps the closing procedure, like writing a receipt for an auditor,
alive for exactly the apply that retires the object.

The block should stay in the code until every environment has applied it, and can then be deleted.
`destroy = false` is the right choice when you are handing an object to another state or tool.
The danger is copying one pattern for the other: either you destroy something you only meant to forget,
or, as here, you leave a "retired" object behind and nobody notices.

Real-world takeaway: before applying a removal, read the plan sentence "will be destroyed" versus "will no
longer be managed". They look similar and mean opposite things.
