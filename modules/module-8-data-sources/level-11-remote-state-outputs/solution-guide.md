# Walkthrough — Ballroom Season Programme

1. **First error.** `Unsupported attribute ... This object does not have an attribute named
   "floor_plan"`. `terraform -chdir=floor-staff output` lists what is really published: `floors`,
   `staff_leads`, `season`. Use `local.plan.floors`.
2. **Second error.** `Invalid index ... a list of string, not a map` for
   `staff_leads["calling"]`. The output is a list ordered by seniority; the head caller is the first
   element: `local.plan.staff_leads[0]`.
3. `terraform apply` -> `total_couples = 160`, `head_caller = "Wilhelmina Pike"`. Type `check`.
