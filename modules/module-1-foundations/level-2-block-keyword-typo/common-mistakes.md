# Common mistakes

- **Fixing only the first error.** Terraform reports both bad blocks; fixing `varible` still leaves `outputs`.
- **Making `outputs` into `outputs = {}`-style attributes.** Output blocks are `output "name" { value = ... }`, one block per output.
- **Removing the variable and hard-coding the string.** The config validates, but the mission needs the
  `lane` input to still drive the booking sheet.
- **Quoting the keyword (`"variable" "lane"`).** Block types are bare words; only labels are quoted.
