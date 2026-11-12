# Common mistakes

- **Giving `beam_m` a default inside the module.** The error disappears, but the module now charges every boat
  as if it were 4 m wide. Changing `vessel_beam_m` would have no effect.
- **Hard-coding `beam_m = 4` in the call.** The default plan passes, but the root variable `vessel_beam_m` is then
  ignored; the second round of checks changes it and the toll does not move.
- **Passing the right value to the wrong name** (`width_m = ...`). Terraform reports an unsupported argument
  and still lists `beam_m` as missing.
- **Deleting the variable from the module** and the formula that uses it. The toll then has no beam component.
