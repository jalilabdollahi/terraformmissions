# Common Mistakes

- **Unescaped double quotes inside a string** — use `\"` to include a literal `"`.
- **Using single quotes** — not valid in HCL. Always use `"..."`.
- **Hash inside a string** — `#` is NOT a comment inside a string literal. Comments only work outside strings.