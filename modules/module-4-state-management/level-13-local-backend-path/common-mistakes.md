# Common mistakes

- **Running `terraform apply` on the "create everything" plan.** It would draw a new tuk-tuk name and write a second state of everything.
- **Editing the path but not running init.** Terraform stops with "Backend initialization required" or keeps using the old initialised backend.
- **Using `terraform init -migrate-state`.** It tries to copy the empty current state over the real one, and it may prompt to overwrite it. `-reconfigure` is what is wanted here.
- **Copying states/tuktuk-prod.tfstate over state/tuktuk.tfstate and leaving the config alone.** It works on your machine but the code still points at the wrong, undocumented file for everyone else.
- **Deleting the `states/` folder to "tidy up".** That is the only copy of production state.
