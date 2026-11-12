# Solution guide

1. `terraform validate`:
   - `"output" attribute is read-only`: output is computed and cannot be configured;
   - `Unsupported attribute`: `terraform_data.batch_record` has no `result` attribute.
2. Provide the data through `input`. Terraform copies it into the computed `output` attribute, which
   is only known after apply.
3. Change the references to `terraform_data.batch_record.output.batch` and `.boxes`.
4. `terraform apply`. Then change the default of `batch_code` and run apply again: `triggers_replace`
   forces a new `terraform_data`, so the log changes.
