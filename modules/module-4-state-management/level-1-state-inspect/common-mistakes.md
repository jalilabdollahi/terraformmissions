# Common Mistakes

- **Typo in resource name** — resource names are case-sensitive; `Gamma` ≠ `gamma`.
- **Confusing resource type with name** — `random_string.gamma` means type=`random_string`, name=`gamma`.
- **Forgetting to run validate before plan** — `terraform validate` catches reference errors immediately.