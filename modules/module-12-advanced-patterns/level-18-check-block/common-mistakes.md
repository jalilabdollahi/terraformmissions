# Common mistakes

- **Editing `silo/status.txt` to say ok.** That silences the warning by hiding the problem; the file belongs to the
  sensor system and the mission wants the warning to remain.
- **Keeping the precondition and adding a check.** The apply would still be blocked.
- **Putting the data source outside the check.** A `check` that reads a normal data source still works, but a failed
  read then stops the plan; the mission asks for the scoped form.
- **Using `postcondition` on the report.** It is still an error, and it would block dependants.
