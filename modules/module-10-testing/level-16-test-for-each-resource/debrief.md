# Wrong Key in for_each Output Assertion

## What Was Broken
The assertion accessed `output.files["wrong_key"]`, but the `for_each` map only has keys
`"alpha"` and `"beta"`. Accessing a non-existent map key causes the test to fail.

## Accessing for_each Outputs
When a resource uses `for_each`, its output (if exported as a map) is indexed by the same keys:
```hcl
output.files["alpha"].content   # correct key
output.files["beta"].filename   # correct key
output.files["wrong_key"]       # error: key does not exist
```

## Checking Available Keys in Tests
If keys are dynamic, use `keys(output.files)` or `contains(keys(output.files), "alpha")` in
conditions rather than hard-coding a key that might not exist.

## Why It Matters
`for_each` resources produce collection outputs that require correct key access. Mistakes in key
names are common when renaming resources or changing input maps.