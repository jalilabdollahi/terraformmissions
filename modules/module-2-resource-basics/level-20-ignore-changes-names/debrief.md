# Debrief: ignore_changes needs real attribute names

`lifecycle { ignore_changes = [...] }` tells Terraform to stop comparing the listed attributes of
a resource between the configuration and the state. It is a surgical tool, and it validates its
arguments against the resource's schema: each entry must be an attribute (or nested path) that
exists on that resource type. Names from your head, from another provider (`contents`, `body`)
or from a different version of the docs produce `Unsupported attribute`.

Choose the narrowest list that does the job. `ignore_changes = all` is tempting but it also hides
drift in everything else; here it would have stopped the schedule from following the config, too.
Also note what ignoring does not do: the attribute stays in config and state as it was at creation, new
resources of the same name will use the new value, and if the resource is ever replaced
for another reason, Terraform will write the *current config value*, not the baker's notes.

Typical real-world uses are fields something else owns: autoscaling's `desired_count`, tags added
by a governance tool, a password rotated outside Terraform. Always write a comment next to the
block saying who owns the attribute and why Terraform lets go of it, otherwise the next reader
believes the config is the truth when it is not.
