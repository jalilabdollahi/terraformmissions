# Debrief — forgetting is not destroying

Terraform's usual contract is: if it is in the state but not in the code, destroy it. Sometimes that
is exactly what you do not want. Ownership of an object moves to another team, another repository,
or a different tool, and the real thing has to keep running.

`terraform state rm <address>` removes the entry from the state only. The real object (here, a file;
in real life a database, a bucket, a DNS zone) is not touched. After that Terraform has no memory
that it ever existed, so you must also delete the block from the configuration. Otherwise the next
plan sees a block with no state entry and proposes to create it again, which for a file overwrites
the new owner's edits.

The order matters: removing the block first and applying would have deleted the file. Always take a
backup first (`terraform state pull > before-rm.tfstate`), run `terraform plan` afterwards, and make
sure it is clean before you walk away.

In modern Terraform the same intent can be written as a `removed` block with
`lifecycle { destroy = false }`, which lives in the code and is reviewed in a pull request. The CLI
command is still the quick tool when you own the state and need to hand an object over today. It is
also the right tool when you are cleaning up after a failed migration and the object must outlive
your state.
