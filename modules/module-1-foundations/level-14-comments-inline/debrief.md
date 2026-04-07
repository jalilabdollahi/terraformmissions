# Comment Catastrophe

## What Was Broken
`/* TODO: expand this` opens a block comment but never closes it. Everything after `/*` —
including the `filename` line and the closing `}` — becomes part of the comment.

## HCL Comment Styles
| Style | Example | Notes |
|-------|---------|-------|
| `#`   | `# comment` | Single-line; preferred by `terraform fmt` |
| `//`  | `// comment` | Single-line; less common |
| `/* */` | `/* multi-line */` | Block comment; must close with `*/` |

## Best Practice
Use `#` for inline comments. Reserve `/* */` only when you genuinely need a multi-line comment block.