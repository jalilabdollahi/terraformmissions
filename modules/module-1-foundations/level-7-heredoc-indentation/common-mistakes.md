# Common mistakes

- **Deleting the indentation of the body inside `main.tf`.** The file comes out right, but the config now
  looks broken and the mission asks for the `<<-` operator.
- **Using `trimspace()` or `chomp()` around the heredoc.** `trimspace` removes the *first* line's
  indentation and trailing newline only, so the other lines stay shifted and the final newline is lost.
- **Writing `<-EOT`.** The operator is `<<-`, with two angle brackets.
- **Mis-indenting a single line.** In `<<-` mode the least-indented line sets the baseline; one line
  at column 0 stops any stripping at all.
