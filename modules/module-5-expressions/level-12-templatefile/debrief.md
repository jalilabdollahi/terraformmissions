# Template File

## What Was Broken
The template file used `${app_name}` but the vars map passed `{ name = var.app }`. The key
`name` ≠ `app_name`, so Terraform could not resolve the placeholder.

## The Fix
```hcl
content = templatefile("${path.module}/app.tpl", { app_name = var.app })
```

## templatefile() Syntax
```hcl
templatefile("<path>", <vars_map>)
```

Template placeholders use `${variable_name}` syntax, and every placeholder in the template
must have a corresponding key in the vars map.

Template directives:
```
%{ if condition }...%{ endif }
%{ for x in list }${x}%{ endfor }
```

## Why It Matters
Template rendering errors only surface at apply time, not at validate time. Always verify that
template variable names exactly match the keys in the vars map.