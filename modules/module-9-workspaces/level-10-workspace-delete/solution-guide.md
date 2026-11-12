# Solution guide

**Diagnose.**

```
terraform workspace delete trial
Error: Workspace is not empty ... Terraform will not delete a workspace that still tracks resources
```

**Fix.**

```
terraform workspace select trial
terraform destroy
terraform workspace select default
terraform workspace delete trial
```

`out/trial-batch.txt` disappears with the destroy. Never run `destroy` while `keep` is selected.
