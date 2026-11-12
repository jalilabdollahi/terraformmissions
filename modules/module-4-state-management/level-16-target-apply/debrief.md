# Debrief — -target is a scalpel, not a habit

`terraform apply -target=ADDRESS` builds a plan from only the named resource and everything it depends
on (and, with `terraform destroy -target`, everything that depends on it). Everything else is ignored: not
refreshed, not evaluated, not created. Here that made the difference between a failed apply and a
published route chart.

You can see the dependency rule at work: we asked for one resource and got two, because
`route_chart` reads `random_id.route_code`. `-target` follows references, but it cannot follow
dependencies that Terraform does not know about, so a missing `depends_on` can cause surprises.

Why Terraform warns every time:

- A targeted apply leaves the rest of the config un-applied, so the state no longer matches the code;
  the next full plan shows the pending work and any error you postponed.
- Habitual use hides problems. If you always target, drift and failing preconditions go unnoticed
  until a full apply fails at a bad moment.

Legitimate uses are recovery (a broken resource blocks everything else), bootstrapping something that
other data sources need (the VPC before the lookup that needs it), and emergency mitigation. Afterwards, run a
full `plan` and clear what remains. For regular splitting of work, use separate root modules or workspaces
instead.
