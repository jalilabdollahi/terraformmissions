# Common mistakes

- **Pinning the provider back to 3.4.0 to get a green pipeline.** The incident is resolved on paper; the
  platform bump is reverted and the next team to touch the code hits the same wall.
- **Deleting `.terraform.lock.hcl` and re-initialising.** It installs 4.x but throws away the checksums the team
  agreed on, and hides the fact that the state still has a 3.x schema.
- **Applying right after init without reading the plan.** If a key had been in the replace list, both pinned
  keys would be gone and every scanner would reject the floor.
- **Blanket `lifecycle { ignore_changes = all }` to silence "forces replacement".** The certificates stay stale and
  the removed arguments still fail validation.
- **Hand-editing the state to add the new attributes.** The provider upgrades its own schema; a hand edit just
  adds a second source of truth.
