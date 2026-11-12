# Walkthrough - Class Iterator

1. `terraform validate` reports *Reference to undeclared resource / There is no variable named "source"*
   inside the `content` block.
2. The `dynamic "source"` block declares `iterator = class`. That makes `class` the loop variable
   (`class.key`, `class.value`) and removes the default `source` variable.
3. Update the two references:
   ```hcl
   filename = class.value.file
   content  = class.value.text
   ```
4. Apply, then `python3 -m zipfile -l bundles/week.zip`. Each list element is an object, hence
   `class.value.file`; for a list the `key` is the position.
