# Debrief - an override only works if the address is right

`override_resource` tells `terraform test` to skip the provider for one resource and use the values you
supply instead. It is the surgical cousin of a mock provider: the rest of the configuration is untouched,
but the one resource whose result you cannot predict (random numbers, timestamps, generated passwords) is
pinned. It can sit at the top of a test file, where it applies to every run, or inside a single `run`.

The target is a static reference: a resource address written without quotes and without any
expression. Resources in child modules need the full path, `module.name.type.name`, and a resource with
`count` or `for_each` needs its index (`type.name[0]`, `type.name["key"]`).

The dangerous part is what happens when the address is wrong. Terraform does not error; it emits
`Warning: Invalid override target` and runs the test with the *real* resource. If the real
resource happens to be harmless (a random number) you just get surprising values. If it is not
harmless, you may create real infrastructure from a test you thought was isolated.

Real-world takeaway: treat warnings in `terraform test` output as failures. Make CI grep for
`Invalid override target`, or run with a wrapper that fails on warnings, and copy addresses from
`terraform state list` or the resource blocks rather than retyping them.
