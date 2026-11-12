# Common mistakes

- **Running `terraform apply` before untainting pine and importing its tag.** The pine run is replaced and a
  new tag number is drawn: the printed pallet labels no longer match the tickets.
- **Untainting everything.** The ash run never completed; leaving it untainted means the corrected kiln name
  is never handshaken and the controller never schedules the lot.
- **Setting `on_failure = continue` on the provisioner.** The apply goes green while the controller still
  rejects ash; the ledger has no ACK for it.
- **Deleting the ash lot from the locals.** The pipeline "succeeds" with two lots and the yard office is a
  ticket short.
- **Guessing the pine tag.** The number to import is in the pine line of `ledger/handshakes.log`; any other
  value is silently accepted by the importer, and the pallet labels no longer match the wood.
