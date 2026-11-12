# Walkthrough — Nightjar Sleeper Manifest

1. `terraform apply` succeeds. `cat manifests/sleeper.txt` shows a blank line after `Berths:`, one
   after every passenger and extra ones around the total.
2. Why: a line in the template that contains only `%{ for ... }` still ends with a newline, and that
   newline is part of the loop body. Compare in `terraform console`:
   ```
   > "a\n%{ for i in [1,2] }x\n%{ endfor }b"      # blank-line mess
   > "a\n%{ for i in [1,2] ~}\nx\n%{ endfor ~}\nb"
   ```
   A `~` just inside the closing brace strips the whitespace (including the newline) after the
   directive; at the start (`%{~`) it strips whitespace before it.
3. Put `~}` on the five line-level directives (`for`, `endfor`, `if`, `else`, `endif`).
   The inline `%{ if p.breakfast } (breakfast)%{ endif }` should keep its spaces, so leave it alone.
4. Apply, read the file, run `check`. The check also renders a one-passenger and an empty train.
