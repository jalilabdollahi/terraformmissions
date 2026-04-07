# Parallelism Tuning

## What Was Broken
The `count` argument was set to `0`, so Terraform would plan to create zero resources — the
config was effectively a no-op. Additionally, an inline comment gave dangerously wrong advice
about the `-parallelism` flag (suggesting `=0`, which Terraform rejects as invalid).

## The Fix
- Change `count = 0` to `count = 10`
- Correct understanding: `-parallelism=N` must be a positive integer. The default is 10.

## Why -parallelism Matters
For large configs with hundreds of resources, Terraform's default parallelism of 10 may be
too aggressive for providers with strict API rate limits (e.g. cloud APIs that throttle
concurrent requests). Lower it to reduce concurrent operations. For local or fast providers,
increasing it speeds up apply significantly.

```bash
# Reduce for rate-limited providers
terraform apply -parallelism=5

# Increase for fast local providers
terraform apply -parallelism=20
```

## Key Takeaway
Always verify resource counts in configs before apply. A `count = 0` is syntactically valid
but silently creates nothing. The `-parallelism` flag controls concurrency; never set it to 0.