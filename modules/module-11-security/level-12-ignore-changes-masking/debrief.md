# Debrief — a quiet plan is not proof of a safe system

`ignore_changes` is a legitimate tool for values that something else manages after creation: autoscaling counts, tags added by a policy engine, a password changed outside Terraform.
Used on the wrong attribute — or as `all` — it turns the plan into a liar. Terraform stops comparing the argument, so a security fix merged in code never lands, a manual
loosening of the real object is never reverted, and the clean plan gives everybody false confidence.

That is why the pattern is dangerous in security-sensitive resources: firewall rules, IAM policies, bucket ACLs, certificate settings, file permissions.
If you must ignore something, name the exact attribute (never `all`), write down why, and keep the security-relevant arguments out of the list. When a plan is noisy, fix the noise at its source
(normalise values, use `lifecycle { replace_triggered_by }` or `moved` blocks properly) rather than hiding it.

A good habit when a fix "does nothing": grep the repo for `ignore_changes`, and compare the real object with the code before trusting a clean plan.
Terraform's `-refresh-only` plan and drift checks in CI help too, but they cannot see through `ignore_changes`.
