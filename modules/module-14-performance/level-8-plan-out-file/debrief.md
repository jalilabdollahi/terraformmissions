# Plan File Workflow

## What Was Broken
The `random_string` resource had `min_lower + min_upper + min_numeric + min_special = 20`
but `length = 12`. The random provider validates that the sum of minimums does not exceed
the total length, and rejects the configuration with an error at plan time.

## The Fix
Increase `length` to `16` and reduce each minimum to `3` (total = 12 <= 16).

## Plan File Workflow
The `plan -out` / `apply <planfile>` pattern is critical for production safety:

```bash
# Step 1: Generate and save plan
terraform plan -out=tfplan

# Step 2: Review the plan (audit, peer review, approval gate)
terraform show tfplan

# Step 3: Apply exactly what was reviewed
terraform apply tfplan
```

**Why it matters:**
- The apply step executes EXACTLY the saved plan — no re-planning, no surprises
- Separates the "plan reviewer" role from the "apply executor" role
- Required for CI/CD pipelines with approval gates (plan in PR, apply on merge)
- Prevents a race condition where a new commit changes the config between plan and apply

## Key Takeaway
Always use `plan -out` in automated pipelines. An unguarded `terraform apply -auto-approve`
without a saved plan re-runs planning at apply time and could pick up unexpected changes.