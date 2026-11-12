# Walkthrough — Lens Lab Gatekeeper

1. **Try to break it.** Add a badly indented line to `main.tf`; run `bash ci/pipeline.sh; echo $?`. The
   script silently reformats the file and prints `pipeline done`, exit 0. Then add a reference to a
   missing resource: validate fails, yet the script exits 0.
2. **Make failures stop the job.** Add `set -euo pipefail`. Every command is a gate; the first non-zero
   exit ends the script with that status.
3. **Make it independent of the caller.** `cd "$(dirname "$0")/.."` moves to the repository root first.
4. **Use the CI-safe flags.**
   - `terraform fmt -check -recursive` fails (exit 3) on unformatted files and changes nothing.
   - `terraform init -input=false` and `terraform plan -input=false` never wait for a human.
   - `terraform plan -out=ci-plan.tfplan` leaves the artifact the apply job will use.
5. **Do not apply.** The gate produces a plan; applying belongs to a separate, approved job.
