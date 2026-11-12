# Solution guide

**Diagnose.**

```
terraform workspace list      # winter exists, selected
terraform state list          # prints nothing
ls -R terraform.tfstate.d
```

`terraform.tfstate.d/summer/terraform.tfstate` follows the pattern. For winter there is an empty directory
and a loose file `terraform.tfstate.d/winter.tfstate`.

**Fix.**

```
mv terraform.tfstate.d/winter.tfstate terraform.tfstate.d/winter/terraform.tfstate
terraform plan
```

The plan now reports no changes, because the original lineage and resources are back.
