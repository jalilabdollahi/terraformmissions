# Common mistakes

- **Hard-coding `staging` in the file name.** The config then writes the same file whichever workspace you
  are in, and the validator rejects it. Select the workspace instead.
- **Running `terraform workspace new staging`.** The workspace already exists, so Terraform refuses.
  `select` switches, `new` creates.
- **Applying before selecting.** You just create a second copy in `default`. Check `terraform workspace show`
  first.
- **Applying in prod "to be safe".** Prod must stay empty; applying there makes it a second mistake.
- **Copying `terraform.tfstate` into `terraform.tfstate.d/staging/` by hand.** That is state surgery for a
  problem one `select` solves.
