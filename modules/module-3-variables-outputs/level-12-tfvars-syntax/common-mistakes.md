# Common mistakes

- **Renaming the file to `.tfvars.json`.** The JSON parser would then reject the HCL-ish comment line and
  the content is still not JSON.
- **Putting `default = ...` into the variable blocks.** The plan runs, but the values no longer come from
  the tfvars file, and the mission checks that.
- **Wrapping everything in `{ }`.** That is JSON syntax; HCL tfvars has no top-level braces.
- **Using `:=` or `=>`.** Those exist in other languages, but HCL attributes use a plain `=`.
