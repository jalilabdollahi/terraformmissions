# Common mistakes

- **Changing `pacing.tf` until the test passes.** The sheet is right; the mission requires the code unchanged in behaviour and the mutants of it must still fail.
- **Replacing a condition with `true`.** All green, nothing tested - the suite is re-run against a broken copy of the code and must fail there.
- **Flipping `slow_runner` to a `default` pace.** That removes the scenario instead of testing it.
- **Fixing only the first failure.** `terraform test` reports every failed assert in a run, but a fixed run can unmask the next one; keep going until the summary says 0 failed.
