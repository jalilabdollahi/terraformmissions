# String Directives

## What Was Broken
`%{if var.debug}` required a boolean, but `var.debug` was typed as `string`. Even though the
string value was `"true"`, it is not a boolean value in Terraform's type system.

## The Fix
```hcl
variable "debug" {
  type    = bool
  default = true   # unquoted boolean, not "true" string
}
```

## String Directives
Terraform supports directives inside string templates:

### %{if}
```hcl
"%{if condition}yes%{else}no%{endif}"
"%{if var.count > 0}has items%{endif}"
```

### %{for}
```hcl
"%{for item in var.list}${item}, %{endfor}"
```

### Tilde strips whitespace
```hcl
"%{if condition~}value%{~endif}"
```

## Why It Matters
`%{if}` is stricter than the ternary operator about type requirements. Always use `bool`
typed variables with string directives to avoid cryptic type errors.