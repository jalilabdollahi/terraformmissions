# Common mistakes

- **Adding `depends_on`.** More edges cannot fix a loop of edges.
- **Typing the SHA-256 into the roster.** It would be stale after the next schedule edit; the validator checks the
  config for hard-coded digests.
- **Deleting the schedule's roster line.** The operators lose the pointer; the schedule must still name `net/roster.txt`.
- **Merging both files into one resource.** The mission needs two files, and the roster has to describe the schedule file.
- **Swapping the direction** (schedule quotes the roster's checksum). The roster must carry the checksum of the schedule.
