# Common mistakes

- **Leaving quotes in the answer file.** `jq .serial` is fine for a number, but strings print with quotes unless you add `-r`; the lineage and hex must be bare.
- **Reading `terraform_version` or the `version` field instead of `serial`.** They are different numbers that sit right beside it.
- **Running `terraform apply` or `refresh` first.** If anything changes, the serial moves and your answer no longer matches the state customs received.
- **Using `terraform state show` for the lineage.** It only shows resource attributes; serial and lineage exist only in the raw JSON.
- **Copying the file `terraform.tfstate` on the side and editing it.** The validator reads the real state; keep the original untouched.
