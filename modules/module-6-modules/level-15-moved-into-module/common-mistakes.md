# Common mistakes

- **Running `terraform apply` before adding the moved blocks.** The old ticket is destroyed and a new one drawn: the
  paperwork is wrong and no `moved` block can bring the old value back.
- **Moving only one resource.** The manifest is recreated; it holds the ticket text, so the file's id changes.
- **Writing `to = module.shed.ticket`.** `to` addresses a resource, not an output.
- **Placing the `moved` blocks inside the module.** `from` must be an address in the module where the block is
  written; to cross the module boundary, the block lives in the caller.
