# Walkthrough - Transcript Optional

1. `terraform plan` fails: *Missing Configuration for Required Attribute ... source[...].content attribute
   as the provider has marked it as required*. The transcript is null by default.
2. You cannot make an argument optional inside a block that always exists; you must make the **block**
   optional. A `dynamic` block with a zero-or-one element collection does exactly that:
   ```hcl
   dynamic "source" {
     for_each = var.transcript == null ? [] : [var.transcript]
     content {
       filename = "transcript-large-print.txt"
       content  = source.value
     }
   }
   ```
3. Apply with the default: a two-entry zip. Apply with `-var transcript=...`: three entries.
4. Keep the two fixed `source` blocks static.
