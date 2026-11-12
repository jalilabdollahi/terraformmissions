# Common mistakes

- **Using plain `terraform fmt`.** It makes the code pass by changing it on the runner; the commit stays
  badly formatted. Only `-check` fails the build.
- **Relying on `set -e` without `-recursive`.** Files in modules/ or components/ are never checked.
- **Putting `-auto-approve apply` at the end "for completeness".** A merge-request gate must not change
  infrastructure; the validator treats any apply as a failure.
- **Chaining steps with `;`.** A failing validate does not stop the plan from running; use `&&` or
  `set -e`.
- **Using a path relative to the caller's directory.** The job passes when started at the repository root
  and breaks when a runner starts it from ci/.
