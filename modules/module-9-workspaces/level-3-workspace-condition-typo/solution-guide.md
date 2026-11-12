# Solution guide

**Diagnose.** In the prod workspace:

```
terraform workspace show        # prod
echo 'local.is_prod' | terraform console    # false
```

`terraform output retention_days` prints 7 and there is no `pager_roster` in `terraform state list`.
Look at `locals`: `terraform.workspace == "prd"`.

**Fix.** Change `"prd"` to `"prod"`. Do not loosen the condition to `!= "dev"`, because the staging workspace
would then be treated as production.

`terraform output` in prod should print `retention_days = 90`, and `out/pager-roster.txt` appears.
