# Common mistakes

- **Deleting the `provider =` lines.** Both tags then use the default configuration; the config
  validates but the audit trail loses the pit information, and the state check fails.
- **Renaming the aliases to match the typo.** Changing the alias to `south` fixes the error but
  leaves the quoted north reference in place and breaks the naming used elsewhere in the dig log.
- **Keeping the quotes because it "works".** Quoted references are deprecated; the mission wants
  bare references.
- **Adding a default `provider "random" {}` block.** That does not create the missing alias.
