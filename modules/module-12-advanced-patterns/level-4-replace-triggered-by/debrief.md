# Debrief: replace_triggered_by forces a replacement from outside

Most attribute changes are applied in place; only "forces replacement" attributes rebuild an object.
Sometimes the dependency is behavioural and not in the schema: a device must be re-provisioned
when its firmware changes, a VM must be rebuilt when the launch template changes. For that,
`lifecycle { replace_triggered_by = [ ... ] }` says: whenever one of these objects is updated or
replaced, replace me as well.

Each entry has to be a reference to a managed resource, or to an attribute of one, never to a variable or a
data source. A reference to a resource triggers on any change of that resource, an attribute
reference only triggers when that attribute's value changes. That is why choosing the correct
target matters: pointing at the wrong resource is silent. The configuration is valid, the plan
is clean, and the controller simply never gets rebuilt.

`terraform_data` is useful as the "trigger source". Its `input` and `output` attributes give you a
small, always-available resource whose changes you can watch, which is the modern replacement for
`null_resource` with `triggers`.

Real-world takeaway: when you add a replace trigger, test it with a deliberate change and read the
plan for the sentence "has to be replaced due to changes in ...".
