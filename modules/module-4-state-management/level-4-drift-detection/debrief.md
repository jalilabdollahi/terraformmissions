# Debrief — drift has two possible cures

**Drift** is any difference between what Terraform believes (state), what the code says, and what
really exists. It appears when humans use consoles, scripts or SSH sessions to change a managed
object.

`terraform plan` already refreshes state before comparing, but it mixes drift with your own code
changes. `terraform plan -refresh-only` isolates the drift: it shows only what changed in the real
world, and `terraform apply -refresh-only` can accept those changes into the state without touching
anything else.

Once you know what changed, there are exactly two ways to reconcile:

1. **The code wins.** Run a normal `apply` and Terraform overwrites the manual change. Right when the
   edit was a mistake or an emergency hack that should not live on.
2. **The reality wins.** Update the configuration to describe the edited object, then bring the state
   in line. Right when the human fix was correct, as the technician's was here.

Neither is automatically better; the mistake is to apply blindly. A blind `apply` here would have
silently ruined a batch of glaze firings. In production, send drift reports to a human and
decide per resource.

Also note how this provider behaves: `local_file` reports an edited file as "deleted", while most
cloud resources report attribute-level changes. Read the plan text before you decide.
