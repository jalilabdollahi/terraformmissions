# CI/CD Pipeline Performance

## What Was Broken
1. **Wrong provider source**: `hashicorp-legacy/random` does not exist. The correct source is
   `hashicorp/random`. Provider sources follow the format `{namespace}/{type}`.
2. **Missing lock file**: Without `.terraform.lock.hcl` committed, every CI run performs full
   version resolution from the registry — slow and potentially non-deterministic.

## The Fix
1. Correct the provider source to `hashicorp/random`
2. Run `terraform init` to generate the lock file
3. Commit `.terraform.lock.hcl` to version control

## CI/CD Performance Playbook

### 1. Lock File Strategy
```bash
# Commit the lock file to your repo after initial init or version upgrades
git add .terraform.lock.hcl
git commit -m "chore: update terraform provider lock file"

# In CI: use readonly to validate against committed lock, skip resolution
terraform init -lockfile=readonly
```

### 2. Provider Cache
```bash
export TF_PLUGIN_CACHE_DIR=/opt/ci/terraform-cache
terraform init  # populates cache on first run; symlinks on subsequent runs
```

### 3. Plan File Approval Gate
```bash
# CI Stage 1 (on PR): generate plan
terraform plan -out=tfplan
# Store tfplan as CI artifact

# CI Stage 2 (on merge/approval): apply saved plan
terraform apply tfplan
```

### 4. Parallelism Tuning
```bash
terraform apply -parallelism=20  # for large configs with high-throughput providers
```

## Key Takeaway
The three pillars of fast, reliable CI/CD with Terraform: committed lock files for
reproducibility, provider caching for speed, and saved plan files for safety and auditability.