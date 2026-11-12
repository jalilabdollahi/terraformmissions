# Common mistakes

- **Moving the scripts into a new `scripts/` folder.** That fixes only `bore`; the other two data
  sources still fail, and the task says the probes stay where they are in `probes/`.
- **Fixing the permission with `chmod 777`.** It works, but a plain `+x` is enough; world-writable
  scripts that run on every plan are a bad habit.
- **Wrapping `program` in a single shell string** like `["bash -c ..."]`. The first element is the
  executable name, not a command line, so Terraform looks for a file literally called `bash -c ...`.
- **Rewriting the scripts to print constants.** The validator edits `survey/readings.txt` and
  expects the outputs to follow.
- **Replacing the data sources with locals.** The probes are the point of the mission.
