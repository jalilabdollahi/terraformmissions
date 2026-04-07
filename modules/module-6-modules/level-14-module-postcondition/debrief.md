# Inverted Postcondition

## What Was Broken
`condition = self.value == ""` passes only when the output value IS the empty string.
The intent (as shown by the error message) is the opposite: ensure the value is NOT empty.

## Output Postcondition Syntax
```hcl
output "content" {
  value = local_file.result.content
  postcondition {
    condition     = self.value != ""   # passes when non-empty
    error_message = "content output must not be empty."
  }
}
```

## `self` in Postconditions
Inside an `output` block's `postcondition`, `self.value` refers to the output's own value.
Inside a `resource` block's `postcondition`, `self` refers to the resource object.

## Concepts
- `postcondition` — asserts something about the result after creation
- `self.value` — refers to the enclosing output's value
- Inverted logic (`==` vs `!=`) is a very common bug in conditions