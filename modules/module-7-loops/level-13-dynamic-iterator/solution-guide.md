# Walkthrough - Lesson Iterator

1. `terraform validate` reports *Reference to undeclared resource / There is no variable named "source"*
   inside the `content` block.
2. The `dynamic "source"` block declares `iterator = lesson`. That makes `lesson` the loop variable
   (`lesson.key`, `lesson.value`) and removes the default `source` variable.
3. Update the two references:
   ```hcl
   filename = lesson.value.file
   content  = lesson.value.text
   ```
4. Apply, then `python3 -m zipfile -l bundles/week.zip`. Each list element is an object, hence
   `lesson.value.file`; for a list the `key` is the position.
