# Walkthrough — Dunmore Telegram Form

1. `terraform plan` says: `Invalid template interpolation ... vars map does not contain key
   "recipient"`, pointing at line 3 of `telegram.tpl`.
2. List the names the template uses: `station`, `recipient`, `sender`, `body`. List the keys the
   map supplies in `main.tf`: `station`, `to`, `from`, `message`.
3. Align them. Either edit the template placeholders or rename the map keys; renaming the keys is
   the smaller change:
   ```hcl
   templatefile("${path.module}/telegram.tpl", {
     station   = var.station
     recipient = var.recipient
     sender    = var.sender
     body      = var.body
   })
   ```
4. Apply, read `outbox/telegram.txt`, run `check`. Keys in the map that the template does not use
   are harmless, but every placeholder needs a key.
