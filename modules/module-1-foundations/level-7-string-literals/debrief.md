# Quote Disaster

## What Was Broken
The `content` string was not closed with a matching `"`. Everything after the opening quote
(including the `#` comment) was treated as part of the string.

## HCL String Rules
- Strings are always delimited with **double quotes** `"..."`
- Single quotes are not valid in HCL
- To include a double quote inside a string, escape it: `\"`
- To include a newline, use `\n` or a heredoc (`<<-EOF`)

## When to Use Heredocs
For multi-line content, prefer heredocs:
```hcl
content = <<-EOF
  line 1
  line 2
EOF
```