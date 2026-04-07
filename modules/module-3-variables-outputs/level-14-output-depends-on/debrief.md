# Output Depends on a Ghost

## What Was Broken
`depends_on = [local_file.nonexistent]` references a resource that doesn't exist. All references
in `depends_on` must resolve to real resources.

## The Fix
```hcl
output "config_path" {
  value      = local_file.config.filename
  depends_on = [local_file.config]
}
```

Or remove `depends_on` entirely — since the output value already references `local_file.config.filename`,
Terraform automatically infers the dependency.

## `depends_on` on Outputs
Output `depends_on` is rarely needed. It is useful when:
- The output value doesn't directly reference a resource, but the output's correctness depends on it
- A side-effect resource must complete before the output is meaningful

```hcl
output "endpoint_url" {
  value      = "https://example.com"
  depends_on = [aws_route53_record.example]  # DNS must exist before URL is useful
}
```

## Why It Matters
The same rules apply to `depends_on` everywhere: all references must resolve to real resources.
A copy-paste error in `depends_on` causes an immediate validate failure.