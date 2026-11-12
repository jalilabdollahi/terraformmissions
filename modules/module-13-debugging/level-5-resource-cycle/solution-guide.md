# Walkthrough - Patrol Roster Cycle

1. `terraform validate` fails with `Error: Cycle: local_file.patrol_roster, local_file.patrol_schedule`.
2. List what each resource reads:
   - roster -> `local_file.patrol_schedule.content_sha256` (a computed value: unavoidable)
   - schedule -> `local_file.patrol_roster.filename` (an *argument you wrote*, so it is known without the resource)
3. Only the computed dependency is a real one. Break the other: put the path in a local value
   (`roster_path = "${path.module}/patrol/roster.txt"`) and use it in both files.
4. Optionally check the arrows with `terraform graph | grep -E "roster|schedule"`; only
   roster -> schedule is left.
5. `terraform apply`, `check`.

`depends_on` would not help: it adds an edge, it never removes one.
