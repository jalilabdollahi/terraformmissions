# Walkthrough — Marta And Idris Invitations

1. **Run `terraform plan`.**
   ```
   Error: Invalid function argument
     on main.tf line 9, in locals:
      9:   header = file("header.txt")
   Invalid value for "path" parameter: no file exists at "header.txt"; this function works only with files that are
   distributed as part of the configuration source code, so if this file will be created by a resource in this configuration you
   must instead obtain this result from an attribute of that resource.
   ```
2. **Look at the disk.** `ls templates/` shows `header.txt` and `footer.txt`. They are not in the working directory.
3. **Anchor the path.** `path.module` is the directory of the module whose configuration contains the expression. Write
   `file("${path.module}/templates/header.txt")` and the same for the footer.
4. **Apply** and `cat letters/invitation.txt`.
