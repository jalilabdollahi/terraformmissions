# Walkthrough — Puppet Theatre Season Bill

1. **First error.** `Unsupported attribute ... This object does not have an attribute named
   "stage_plan"`. `terraform -chdir=stage-crew output` lists what is really published: `stages`,
   `crew_leads`, `season`. Use `local.plan.stages`.
2. **Second error.** `Invalid index ... a list of string, not a map` for
   `crew_leads["rigging"]`. The output is a list ordered by seniority; the head rigger is the first
   element: `local.plan.crew_leads[0]`.
3. `terraform apply` -> `total_seats = 160`, `head_rigger = "Wilhelmina Pike"`. Type `check`.
