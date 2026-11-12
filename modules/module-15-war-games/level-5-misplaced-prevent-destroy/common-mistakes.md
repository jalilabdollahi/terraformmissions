# Common mistakes

- **Deleting the whole `prevent_destroy` collection and moving on.** The annex goes, but nothing protects the
  charter, and the next careless change to `keepers` or the yard name replaces it.
- **Applying as soon as the annex guard is gone.** Without a guard on the charter, the plan quietly replaces
  `random_id.yard_charter`, because `keepers.annex` flips to "false". The harbour authority now holds a stale serial.
- **`terraform destroy -target=module.annex`.** It fails on the same guard, and `-target` leaves the manifest
  broken even when it succeeds.
- **Setting `annex_enabled = true` again.** The plan goes clean and the decommission ticket is never done.
- **`ignore_changes = all` on the charter.** It hides the trap instead of removing it, and it makes the real
  guard meaningless.
