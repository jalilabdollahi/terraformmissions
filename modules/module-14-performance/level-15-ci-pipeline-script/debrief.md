# Debrief — a pipeline is a list of gates, not a list of commands

The same four commands that a person types become a pipeline only when each one can **stop** the run.
Each step answers one question: is the code formatted (`fmt -check`), can the providers be installed
(`init`), is the configuration valid (`validate`), and what would change (`plan`)? Order matters: it is
cheap to fail on formatting before spending a minute downloading providers, and `validate` needs
`init` first.

CI-specific details that bite people:

- **`-input=false`** (or `TF_INPUT=0`): a prompt in an unattended job hangs until the runner times out,
  or fails with an unhelpful error. Missing variables should be a clear failure.
- **`fmt -check`, never plain `fmt`** in CI: a job that rewrites files changes nothing in the commit
  and passes while the repository stays unformatted.
- **Fail fast**: `set -e` (with `pipefail`) or explicit exit-code handling. A script that ends in an
  `echo` reports success whatever happened before.
- **`plan -out`**: save the exact plan so that the apply job (after approval) applies what was
  reviewed. Treat the file as sensitive.
- **`terraform fmt -recursive`** also covers modules and components in subdirectories.
- **No `apply` in the merge-request job**; set `TF_IN_AUTOMATION=1` to make output friendlier to logs.

Real-world takeaway: write the pipeline as a script that is tested like code: run it against a good
repo, an unformatted repo, an invalid repo, and a repo that needs input. Each must end the way you
expect.
