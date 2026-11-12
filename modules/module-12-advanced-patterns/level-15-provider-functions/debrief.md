# Debrief: provider functions need the provider declared

Terraform 1.8 added functions that live in providers and are called as `provider::<name>::<function>`.
The built-in `terraform` provider, which is part of Terraform itself, ships three: `encode_tfvars`,
`decode_tfvars` and `encode_expr`. They exist to solve a long-standing chore: producing HCL text from Terraform
values without brittle string templates. `encode_tfvars` sorts attribute names, quotes strings,
formats lists and nested objects, and aligns the equals signs. Doing that by hand with `join` and `format` means
you must also escape quotes and keep up with new fields.

The part that surprises people is the declaration. Unlike core functions like `join`, a provider function is only in scope if
the provider appears in the module's `required_providers` under the name you use in the call. That is true even for
the built-in provider, whose source is `terraform.io/builtin/terraform`. The module's local name must match
the middle part of the call: `required_providers { terraform = ... }` gives `provider::terraform::...`.
You can pick another local name and call `provider::tf::encode_tfvars`.

The decode direction is useful too: `decode_tfvars` turns the text of a `.tfvars` file back into an object, so
a configuration can compare or merge settings from another stack without an external script.

Real-world takeaway: when a function call fails with "Unknown provider function", check the provider
declaration and the local name before the function name.
