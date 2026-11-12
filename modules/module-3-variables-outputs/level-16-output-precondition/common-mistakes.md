# Common mistakes

- **Adding a `validation` block to `affinage_days`.** It would reject young wheels but would also reject
  them for any other purpose; the mission wants the output guarded, and the check looks for the output
  precondition message.
- **Hard-coding `>= 60`.** The threshold is a variable; the check raises it to 45 and expects the guard to follow.
- **Using `>` instead of `>=`.** A wheel at exactly 60 days is old enough; the boundary matters.
- **Putting the precondition on the `local_file`.** The shop reads the output, not the file, and the check
  looks for a failure from the output's precondition.
