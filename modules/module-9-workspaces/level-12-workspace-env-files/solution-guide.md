# Solution guide

**Diagnose.**

1. In dev, `terraform plan` says *Unsupported attribute ... This value does not have any attributes* for
   `local.settings.spin_seconds`: `file()` produced a string.
2. `ls env/` shows `dev.yaml`, `staging.yaml` and `production.yaml`. The workspace is `prod`, so
   `file("env/prod.yaml")` fails with "no file exists".

**Fix.**

```hcl
settings = yamldecode(file("${path.module}/env/${terraform.workspace}.yaml"))
```

and `mv env/production.yaml env/prod.yaml`. Renaming the file is the right choice: the workspace names are
the keys, and the files follow them.
