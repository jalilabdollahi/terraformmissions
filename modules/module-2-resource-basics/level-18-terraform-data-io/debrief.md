# Debrief: terraform_data is a typed scratchpad

`terraform_data` is Terraform's built-in, provider-less resource. It replaces the old `null_resource`
for most uses and has three attributes worth knowing:

- `input`: any value you give it (maps, lists, numbers);
- `output`: a computed copy of `input`, known after apply; read this one from other resources, so
  downstream resources only update when the record is really applied;
- `triggers_replace`: when this value changes the resource is destroyed and created again, which
  re-runs any provisioner and gives it a new `id`.

The mix-up in this level is natural: `output` sounds like what you set when you describe what the
resource produces, and `result` is what the random provider calls its value. Neither works. Remember:
you write `input`, you read `output`.

Because it lives in state, `terraform_data` is also the standard way to make a non-resource value
participate in the plan: `lifecycle { replace_triggered_by = [terraform_data.x] }` on another
resource is the common pattern, to force a replacement when a plain variable changes.
