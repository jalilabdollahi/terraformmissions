# Walkthrough - Zip By Another Name

1. `terraform validate` says: *Unsupported block type - Blocks of type "files" are not expected here* on the
   `dynamic "files"` line.
2. In `dynamic "NAME" { ... }` the label NAME *is* the nested block type being generated. `archive_file`
   has a repeatable nested block called `source` (arguments `filename` and `content`).
3. Rename the label. The iterator variable defaults to the label, so update the references too:
   ```hcl
   dynamic "source" {
     for_each = var.documents
     content {
       filename = source.key
       content  = source.value
     }
   }
   ```
4. Apply and look inside: `python3 -m zipfile -l dist/trip-pack.zip` lists the three documents.
