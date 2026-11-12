# Debrief: destroy-time code can only see its own resource

`self` is the object a provisioner is attached to. For create-time provisioners it is a convenience; for
destroy-time provisioners it is mandatory. Terraform saves the resource's attributes in state, but the rest of
the configuration may have changed or vanished by the time a destroy runs: the block might be deleted
(think of a `removed` block), a variable might be unset, another resource might be destroyed first. If a destroy
provisioner could reference them, destroys would sometimes fail, or form dependency cycles with
`create_before_destroy`. So Terraform's rule is strict, and it checks it at validate time.

The practical consequence is a design habit: anything a destroy provisioner needs must be stored on the
resource. `terraform_data` is ideal because its `input` can carry arbitrary values (here ticket and
clock), and `self.input.ticket` reads them back from state. For other resources you put values in
`triggers` or tags and read them through `self`.

Provisioners remain a last resort, as the Terraform docs say, since a failing script leaves a tainted
resource and the log line is only written on this machine. But where you must use them, the `self` rule is what makes cleanup
reliable.

Real-world takeaway: when a destroy provisioner complains about references, copy the needed value into the
resource, then read it through `self`.
