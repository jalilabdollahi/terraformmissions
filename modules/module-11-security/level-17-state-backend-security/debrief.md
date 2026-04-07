# Hardcoded Secret in Backend Config Comment

## What Was Broken
A commented-out AWS access key and secret key appeared in `terraform.tf`. Even as comments,
credentials in source code are a serious security violation because:
- Git history is permanent — even if removed, they can be recovered.
- CI/CD systems log file contents.
- Developers clone repos to local machines, spreading the credentials.

## Correct Backend Credential Patterns

### Environment Variables (Recommended)
```bash
export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
export AWS_SECRET_ACCESS_KEY="..."
terraform init
```

### Partial Backend Config File (Never Committed)
```bash
# backend.hcl — add to .gitignore
access_key = "AKIAIOSFODNN7EXAMPLE"
secret_key = "..."
```
```bash
terraform init -backend-config=backend.hcl
```

### IAM Instance Profiles / OIDC (Best for CI)
Use cloud-native auth (EC2 instance profiles, ECS task roles, GitHub Actions OIDC) so
no static credentials are ever needed.

## Why It Matters
Hardcoded credentials in source control are one of the top causes of cloud account compromises.
Tools like `git-secrets`, `truffleHog`, and `detect-secrets` scan for them — use them in CI.