# Debrief — nothing leaves a module unless it says so

Variables are the doors into a module and outputs are the doors out. A resource inside `modules/tower` exists in
the plan as `module.tower.local_file.roster`, but no expression in the *root* configuration can mention it. The
only way for the root to learn the file path or the computed chime is for the module author to publish an
`output` block. If the author forgets, the root sees `module.tower` as an object without that attribute,
and Terraform reports exactly that.

This is the mirror image of an input mistake. Here the caller is right and the module is incomplete, so you fix
the child. Deciding *which side to fix* is a core module skill: ask who owns the contract. If the root already
names an output that makes sense (`next_chime`) and a module gives no other way to obtain it, adding the output is
the honest completion of the interface.

When you add outputs, expose values rather than internals. `local.next_chime` is a computed fact about the
tower; `local_file.roster.filename` is the path as Terraform resolved it. Neither exposes the whole resource
object, which keeps callers from depending on provider-specific attributes that might change.

Outputs also create dependencies: anything the root builds from `module.tower.roster_file` waits for the file to
be written, because the output value goes through the resource.

**Takeaway:** when a reference to a module attribute fails and the name is reasonable, check whether the module
declares that output; if not, add it, sourced from the real local or resource attribute.
