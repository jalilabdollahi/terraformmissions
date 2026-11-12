# Common mistakes

- **Editing `floor-staff/main.tf` to add `floor_plan`.** That is another team's configuration, and the
  state the front desk reads would not change until the staff re-applied. The consumer adapts.
- **Fixing the name but not the index.** The second error appears right after the first.
- **Converting with `tomap(...)` to keep `["calling"]`.** A list has no such key; conversion
  produces keys "0", "1", not role names.
- **Hard-coding 160 and the caller's name.** The validator changes the staff's couples and leads and
  expects the front desk to follow.
- **Dropping the `terraform_remote_state` data source for a local value.** The mission is about
  reading the staff's outputs.
