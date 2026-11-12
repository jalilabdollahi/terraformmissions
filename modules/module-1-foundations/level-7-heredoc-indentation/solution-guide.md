# Walkthrough — Copper Kettle Menu

1. **Apply and look.** `terraform apply`, then `cat -A tavern/menu.txt`. Every line starts with four
   spaces; the dishes have six.
2. **Compare with the config.** The heredoc body in `main.tf` is indented four spaces (to line up with
   the `content` attribute) and `<<EOT` keeps those spaces verbatim.
3. **Use the indented heredoc.** Change `<<EOT` to `<<-EOT`. Terraform finds the *smallest* indentation of
   any line in the body (four spaces) and removes exactly that much from every line.
4. **Apply again.** The file is replaced; the dishes keep their two spaces relative to the title.
