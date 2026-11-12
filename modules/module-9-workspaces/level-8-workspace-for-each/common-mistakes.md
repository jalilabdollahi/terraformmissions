# Common mistakes

- **Switching to `count = length(local.active)`.** It plans, but the instances become `perch[0]`, `perch[1]`,
  and the validator wants station-keyed addresses. The duplicate `dovecote` also becomes a fifth card.
- **Editing the list in the map to remove the duplicate.** Tidy, but the mission is the type error, and the
  fix with `toset` handles any future duplicate too.
- **Using `for_each = local.stations`.** That iterates over workspaces, not stations.
- **`tomap(local.active)`.** A list of strings cannot become a map without keys.
