# Debrief: workspaces start empty unless you seed them

A new workspace starts with *no state at all*, however much infrastructure the other workspaces manage.
Applying in it would create everything again, and for a `random_pet` that means a new, different
name. If you want a copy of what exists elsewhere, the intent has to be explicit. `terraform workspace new
-state=FILE NAME` creates the workspace with a copy of the given state file as its starting point. Every
resource, ID and output in it arrives intact.

Remember what this actually does. The *state* is copied; the real objects are not. Both states now
describe the same real files, so if the config uses fixed names, as it does here, the two workspaces
manage the same object and a destroy in one will break the other. In practice, seeding is useful for:

- restoring a backed-up state into a recovery workspace;
- rehearsing an upgrade or a refactor (`state mv`, provider bump) on a copy before touching the real
  one, which is the point of the "rehearsal" workspace here;
- splitting work out of a single-state project.

The same effect is available the other way round: `terraform state pull > backup.tfstate` makes the
snapshot, `terraform state push` writes one into the current workspace.

**When workspaces are the wrong tool:** a rehearsal that shares real object names with its source is not
isolated. If the rehearsal may apply or destroy, it needs different names or a different account, which
means different configuration inputs, and a separate directory is often cleaner than a workspace.
