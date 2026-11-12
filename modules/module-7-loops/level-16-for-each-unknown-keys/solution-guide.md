# Walkthrough - Keys From The Future

1. `terraform plan` fails: *Invalid for_each argument ... The "for_each" map includes keys derived from
   resource attributes that cannot be determined until apply, and so Terraform cannot determine the full
   set of keys*.
2. The offending values are `random_id.run.hex` inside `local.label_keys`. The key set is built from it,
   so Terraform cannot even tell how many or which instances to plan.
3. Separate identity from content: key by the sample name, which is known, and use the run id in the
   arguments, which may be unknown until apply:
   ```hcl
   for_each = toset(var.samples)
   filename = "${path.module}/labels/${each.key}-${random_id.run.hex}.txt"
   ```
4. Apply: the labels get `-<run id>` suffixes, and the addresses stay `local_file.label["kelp-a"]`.
