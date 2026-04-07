# Wrong Output Reference Across Run Blocks

## What Was Broken
The assertion used `run.first.output.file_path` — a non-existent reference syntax. In Terraform
native tests, multiple `run` blocks within a single test file share the same ephemeral state.
Outputs are accessed using the flat `output.<name>` syntax regardless of which `run` block
produced the resource.

## How State is Shared Between Run Blocks
```
run "first"  →  applies resources  →  state contains local_file.out
run "second" →  operates on same state  →  output.file_path is still accessible
```

## Why There Is No run.X.output Syntax
Terraform tests do not expose per-run namespaced outputs. If you need to test a transition
(apply → destroy → re-apply), each step still reads from the common test state.

## Why It Matters
Understanding how state flows through multiple `run` blocks is essential to writing correct
multi-step integration tests.