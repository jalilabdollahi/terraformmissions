# Common mistakes

- **Moving the key to `default = "..."` in the variable block.** It is still committed plaintext, now in a `.tf` file.
- **Renaming the file to `secrets.tfvars` and committing it.** Same repository, same leak. Ignoring it is better, but the validator also looks for the key under any name.
- **Commenting the line out.** Commented text is still text in git, and the validator greps for the key itself.
- **Hard-coding the key in the `local_sensitive_file` content.** That removes the variable entirely and the credentials file no longer follows the environment value.
- **Forgetting to rotate the leaked key.** Not checked by the game, but it is the step that actually closes the incident.
