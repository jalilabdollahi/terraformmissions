# Common mistakes

- **Allowing zero lanes in the module.** `var.lane_count >= 0` removes the error and creates an empty
  alley. The validator expects the module's validation to be intact.
- **Adding a `pr-142` branch to the ternary.** It fixes one workspace. The next one (`hotfix-7`) fails
  the same way, and the validator tries another name.
- **Defaulting the fallback to 4.** Every throwaway workspace would then be the size of production.
- **Dropping the module and writing the files in the root.** The module is part of the design here.
