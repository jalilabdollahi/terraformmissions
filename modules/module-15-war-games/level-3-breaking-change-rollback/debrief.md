# Breaking Change Rollback — Incident Post-Mortem

## The Incident
A provider upgrade introduced a breaking change: the attribute name changed from the expected
name to a different one. Configs that were not updated before the upgrade broke immediately.

In this scenario, `char_count` was the wrong attribute name — the correct name is `length`.
This simulates the class of breaking changes where attribute names are renamed across major
provider versions.

## Provider Upgrade Checklist
Before upgrading a provider:
1. **Read the CHANGELOG** — look for `BREAKING CHANGES` section
2. **Run plan with new version in a non-prod workspace first**
3. **Check for deprecated warnings** — deprecated attributes often become errors in next major version
4. **Update all attribute references** before or immediately after the version pin change
5. **Have a rollback plan** — keep the previous provider version constraint available

## Rollback Procedure
```bash
# 1. Revert terraform.tf to previous provider version constraint
# 2. Run terraform init -upgrade to downgrade
terraform init -upgrade

# 3. Plan to confirm old config works with old provider
terraform plan

# 4. Apply the rollback
terraform apply
```

## Key Takeaway
Never upgrade providers in production without reading the CHANGELOG and testing in a
lower environment first. Use the lock file to pin versions and upgrade deliberately,
not accidentally (i.e. never use `>= x.y` without an upper bound in production).