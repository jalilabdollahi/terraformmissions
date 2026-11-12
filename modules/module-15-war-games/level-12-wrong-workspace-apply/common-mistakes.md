# Common mistakes

- **Running `terraform destroy` in staging and re-applying in prod.** The four keys are already in race control's loaded cards; recreating them rotates every post key during a live incident window.
- **Copying staging's whole state file over prod's.** That makes prod forget its own region seed and imports staging's seed instead; the seed ID no longer matches.
- **Only moving the state.** With `env = "prod"` still hard-coded, the staging workspace keeps wanting to build the prod posts again on the next plan.
- **Only fixing the config.** Switching to `terraform.workspace` while the post objects sit in staging makes the staging plan destroy them and the prod plan create new ones.
- **Forgetting to select the workspace before planning.** A clean plan in staging says nothing about prod; check both.
