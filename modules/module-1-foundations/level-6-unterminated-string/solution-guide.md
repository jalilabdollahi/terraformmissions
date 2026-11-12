# Walkthrough — Marlowe Museum Placards

1. **Run `terraform validate`.** The first error is:
   ```
   Error: Invalid multi-line string
     on main.tf line 9, in resource "local_file" "gallery_four":
      9:   content  = "Gallery 4: Impressionists, 1870-1890\nCurated by ${var.curator}\n
   Quoted strings may not be split over multiple lines. To produce a multi-line string,
   either use the \n escape to represent a newline character or use the "heredoc" multi-line template syntax.
   ```
   Further errors about the following lines are *consequences*: the parser thinks the string never ended.
2. **Fix the first error only.** Add the closing `"` at the end of line 9.
3. **Re-run validate**; the other errors disappear. Then `terraform apply`.
