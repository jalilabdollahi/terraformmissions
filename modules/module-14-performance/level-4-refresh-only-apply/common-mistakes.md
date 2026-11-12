# Common mistakes

- **Running `terraform apply`.** It records the new rainfall, but it also replaces banner.txt with the
  unreviewed text, which is exactly what the mission forbids.
- **Reverting the banner edit in variables.tf to get a clean plan.** The colleague's work is lost; the
  mission requires it to stay in the code, un-applied.
- **Editing the feed file back to the old reading.** The logger owns that file; the real value is
  11.8 mm and the state has to learn it.
- **Using the deprecated `terraform refresh`.** It writes the same state, but it applies without
  showing you a plan to review, and the habit is dangerous with unfamiliar drift.
