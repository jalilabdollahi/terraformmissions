# Wrong Test Assertion

## What Was Broken
The assert condition `output.result == "wrong"` always fails because the module outputs `"correct"`.

## Writing Good Assertions
```hcl
assert {
  condition     = output.result == "correct"   # matches actual output
  error_message = "result should equal 'correct'"
}
```

## Tips for Test Assertions
1. Run the module manually (`terraform apply`) and inspect outputs to know expected values.
2. Keep `error_message` informative — include what was expected.
3. Test both the happy path and edge cases.

## Multiple Assertions
A single `run` block can have multiple `assert` blocks:
```hcl
run "full_check" {
  command = apply

  assert {
    condition     = output.result == "correct"
    error_message = "wrong result value"
  }

  assert {
    condition     = output.result != ""
    error_message = "result must not be empty"
  }
}
```

## Concepts
- `assert` blocks are the heart of Terraform testing
- `condition` must evaluate to `true` for the test to pass