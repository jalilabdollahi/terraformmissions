# Missing Resource Referenced in Assertion

## What Was Broken
The second `run "check"` block asserted `output.manifest_path`, but `main.tf` had no
`local_file.manifest` resource and no `manifest_path` output. The test was written ahead of the
implementation.

## Multi-Run Test Pattern (Setup + Verify)
```hcl
run "setup" {
  command = "apply"
  # Optionally override variables for initial state
}

run "verify" {
  command = "apply"
  # Assert on outputs produced by setup
  assert {
    condition     = output.manifest_path != ""
    error_message = "Manifest path should be set."
  }
}
```

## Key Points About Multi-Run Tests
- Both runs share the same ephemeral test state.
- Resources created in `run "setup"` are available in `run "verify"`.
- After all `run` blocks complete, Terraform destroys the test state automatically.
- You can use `run "teardown" { command = "apply" }` with a variables override to simulate
  destruction of specific resources mid-test.

## Why It Matters
Test-driven development (writing tests before the implementation) is a powerful practice. But
the test must match the final implementation. When a test references a resource or output that
doesn't exist, the fix is to implement the missing piece in the config.