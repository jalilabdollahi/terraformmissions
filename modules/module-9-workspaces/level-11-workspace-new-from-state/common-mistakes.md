# Common mistakes

- **`terraform workspace new rehearsal` followed by `terraform apply`.** You get a fresh codename and the
  jar label card is overwritten. Seeding has to happen at creation or by `state push`.
- **Copying the snapshot over `terraform.tfstate`.** That is the *default* workspace's state; rehearsal is
  still empty.
- **Using `-state=` after the workspace exists.** The flag only works with `workspace new`.
- **Importing the resources one by one.** It would work for the file, but `random_pet` cannot be imported
  with its original value.
