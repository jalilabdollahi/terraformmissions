# String Escape

## What Was Broken
HCL does not allow a regular quoted string to span multiple lines. The newline inside `"..."` is a syntax error.

## Solutions for Multi-line Strings

**1. Escape sequences** (for simple cases):
```hcl
content = "line1\nline2\nline3"
```

**2. Heredoc** (for readable multi-line content):
```hcl
content = <<-EOF
  line 1
  line 2
EOF
```

**3. `file()` function** (for external files):
```hcl
content = file("${path.module}/script.sh")
```

Use heredocs for any content that is more than one line.