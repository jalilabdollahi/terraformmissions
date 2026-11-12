# Walkthrough - Two Deckhands One Card

1. `terraform apply`, then `ls cards/`: only `captain.txt`, `deckhand.txt`, `engineer.txt`. Open
   `captain.txt` - it reads `Name: captain`, `Role: mara`.
2. In `for_each = var.crew`, `each.key` is the *key* of the map entry (mara) and `each.value` is the
   *value* (captain). The config has them reversed in both the filename and the content.
3. Edit the resource:
   ```hcl
   filename = "${path.module}/cards/${each.key}.txt"
   content  = "Name: ${each.key}\nRole: ${each.value}\n"
   ```
4. Apply. Terraform replaces the old files, `deckhand.txt` disappears and four sailor cards remain.
