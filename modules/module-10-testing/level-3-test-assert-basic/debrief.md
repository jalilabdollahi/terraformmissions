# Wrong Expected Value in Assert

## What Was Broken
The `assert` block compared `output.result` against `"wrong_value"`, but the output always produces
`"correct_value"`. The test was set up to always fail.

## Reading Test Failure Output
When an assert fails, `terraform test` prints:
```
Error: Test assertion failed
  on tests/main.tftest.hcl line N, in run "check_result":
  N:     condition = output.result == "wrong_value"
    ├─────────────────
    │ output.result is "correct_value"
```
This tells you the actual value so you can correct the expectation.

## The Fix
```hcl
condition = output.result == "correct_value"
```

## Why It Matters
An assert that always fails (or always passes regardless of configuration) provides no value.
Test conditions must reflect the real intended behaviour of your module.