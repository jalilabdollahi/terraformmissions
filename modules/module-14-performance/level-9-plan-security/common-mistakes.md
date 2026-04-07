# Common Mistakes

- **Not marking password outputs as sensitive** — they appear in CI/CD logs and terminal history.
- **Thinking sensitive = true encrypts the state** — it does not; state still has plain text values.
- **Forgetting that plan files contain sensitive data** — encrypt, restrict access, and clean up .tfplan files.
- **Reading sensitive outputs directly into config files** — use secret managers as intermediaries.