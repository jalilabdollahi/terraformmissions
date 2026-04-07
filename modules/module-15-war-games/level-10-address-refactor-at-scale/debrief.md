# Address Refactor at Scale — Incident Post-Mortem

## The Incident
A naming convention refactor renamed 5 resources from `svc_*` naming to descriptive
`service_*` names. The config was updated but the `moved` blocks mapping old addresses
to new addresses were missing. Without them, Terraform would plan to destroy 5 resources
and recreate 5 new ones — potentially catastrophic for production services.

## The 5 Renames
```
random_string.svc_one   → random_string.service_alpha
random_string.svc_two   → random_string.service_beta
random_string.svc_three → random_string.service_gamma
random_string.svc_four  → random_string.service_delta
random_string.svc_five  → random_string.service_epsilon
```

## Refactoring at Scale
For large codebases with many resource renames:
1. **Document the rename map** in comments before writing moved blocks
2. **Write a script** to generate moved blocks from a rename CSV
3. **Review the plan carefully** — each rename should show as "moved" not "destroyed + created"
4. **Apply in batches** if the rename is very large

## Alternative: terraform state mv (pre-moved-blocks era)
```bash
terraform state mv random_string.svc_one random_string.service_alpha
# ... repeat for each rename
```
`moved` blocks are preferred — they are declarative, code-reviewable, and idempotent.

## Key Takeaway
Any resource rename without a `moved` block is a destroy + recreate. For production resources,
this is unacceptable. Always pair resource renames with `moved` blocks.