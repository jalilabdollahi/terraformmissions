# Common mistakes

- **Fixing only the comma.** The syntax error goes away and a *type* error takes its place — read the
  second message too.
- **Converting the file to `terraform.tfvars` with HCL syntax.** It works, but the mission is about the JSON
  export from the booking system; the validator wants `terraform.tfvars.json` to stay and be valid.
- **Splitting `site` into `site_lat` / `site_lon` variables.** That changes the interface of the config and
  does not fix the file.
- **Setting `default = ...` on the variables.** The error disappears but the data no longer comes from the
  booking system's file.
