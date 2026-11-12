# Solution guide

**Diagnose**

```
terraform workspace list
```

The asterisk is on `default`, not `staging`. `terraform state list` prints `local_file.groundsman_plan`, which
is the default workspace's state. The file on disk is `out/default-groundsman-plan.txt`, which gives it away,
since the file name is built from `terraform.workspace`.

**Fix**

```
terraform workspace select staging
terraform apply
```

After the apply, `out/staging-groundsman-plan.txt` exists and `terraform plan` reports no changes. The
leftover `default` state is not part of this mission, and prod must stay empty.
