# Walkthrough — Orphaned Freezer Tag

1. **Read the evidence.** `cat inventory/asset-sticker.txt` shows the same value in two encodings:
   hex and URL-safe base64 (barcode).
2. **See what Terraform thinks.**
   ```bash
   terraform plan
   # random_id.freezer_tag will be created
   # local_file.door_label will be updated in-place   (new tag => new label)
   ```
3. **Import.** For `random_id` the import ID is the `b64_url` value:
   ```bash
   terraform import random_id.freezer_tag <barcode string>
   # random_id.freezer_tag: Import prepared!
   # Import successful!
   ```
   The provider documentation lists the ID format per resource type; it differs from resource to
   resource.
4. **Confirm.** `terraform plan` reports "No changes". The door label shows the original hex. Type `check`.
