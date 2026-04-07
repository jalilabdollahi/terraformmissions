# Compound Assertion Always False

## What Was Broken
The compound condition `output.a == "x" && output.b == "wrong"` always evaluates to `false`
because `output.b` produces `"y"`, not `"wrong"`. A condition that can never be true is a
broken test.

## Debugging Compound Assertions
When a compound `&&` condition fails, check each part independently. Terraform's failure output
shows the evaluated values, which makes it easy to identify which part fails.

## Best Practices for Compound Assertions
Consider splitting compound assertions into individual `assert` blocks:
```hcl
assert {
  condition     = output.a == "x"
  error_message = "Output a should be 'x'."
}

assert {
  condition     = output.b == "y"
  error_message = "Output b should be 'y'."
}
```

This gives more precise failure messages. A single `&&` condition only tells you that *something*
was wrong, not which specific output failed.

## Why It Matters
Compound assertions that always fail (or always pass) give false confidence. Every condition
in a test should be reachable in both its true and false state.