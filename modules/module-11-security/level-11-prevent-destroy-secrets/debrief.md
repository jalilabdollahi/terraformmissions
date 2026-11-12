# Debrief — a seat belt, not a vault

`lifecycle { prevent_destroy = true }` makes Terraform refuse any plan that would destroy or replace the resource. It turns an accidental
`terraform destroy`, a renamed resource block or a force-new attribute change into an error that a human has to read and decide on.
For things that are hard or impossible to recreate — a master passphrase, a root key, a database that holds the only copy of data — that pause is worth a lot.

Know its limits. It only guards against plans produced from *this configuration*. If someone deletes the block (or the whole resource) from the code, the
protection disappears with it, and `terraform state rm` or removing the state itself bypasses it entirely. It is also checked at plan time, so a plain `terraform destroy` fails and
leaves everything in place — but a destroy of the whole workspace by deleting the cloud account does not care.

So pair it with other controls: restricted credentials for the pipeline, review of the plan before apply, versioned and encrypted state, and backups of anything irreplaceable.
Also use it deliberately — a `prevent_destroy` that blocks routine replacement (in every environment, including throw-away ones) trains people to remove it, which is worse than not having it.
