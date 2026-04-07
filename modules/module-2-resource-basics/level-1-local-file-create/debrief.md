# The Unreachable Path

## What Was Broken
The `filename` attribute pointed to `/tmp/nonexistent/dir/config.txt`. The `local_file` provider
writes the file directly — it does **not** create intermediate parent directories. Because
`/tmp/nonexistent/dir/` does not exist, the write fails at apply time.

## The Fix
Use `path.module` to write the file into the module directory, which always exists:

```hcl
filename = "${path.module}/config.txt"
```

## Key Concept: `path.module`
Terraform exposes several built-in path references:

| Reference      | Resolves to |
|---------------|-------------|
| `path.module` | Directory of the current `.tf` file |
| `path.root`   | Root module directory |
| `path.cwd`    | Current working directory |

## Why It Matters
Hardcoding absolute paths like `/tmp/...` is fragile — it breaks across machines and CI environments.
Prefer `path.module`-relative paths for portability.