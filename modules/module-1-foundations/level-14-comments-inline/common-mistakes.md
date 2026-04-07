# Common Mistakes

- **Unclosed `/* */`** — the parser treats everything until `*/` as the comment.
- **Using `//` in shell scripts inside `local-exec`** — `//` is a comment in HCL but not in bash.