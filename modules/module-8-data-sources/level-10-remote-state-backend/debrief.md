# Debrief — remote state is a read of someone else's backend

`data "terraform_remote_state"` lets one configuration read the **root-module outputs** another
configuration has stored in its state. The data source does not look at the other team's code; it
opens their backend exactly as `terraform` would, so its `backend` and `config` arguments must
describe that backend precisely: for `local` the file path, for `s3` the bucket, key and region, and
so on. If they do not match, Terraform may find an empty or non-existent state and tells you "no
stored state was found".

In this mission the producer used a non-default state file name. Many teams do that to keep several
state files side by side or to make backups obvious, and the consumer has to follow. Always
copy these settings from the producer's `backend` block rather than guessing the defaults.

A few consequences worth knowing:

- Only outputs are visible. If the depot team wants to share the depot code, they must declare an
  `output`; nothing else crosses the boundary.
- The consumer needs read access to the whole state file, which may contain secrets. Many teams
  prefer purpose-built sharing (a parameter store, a published JSON document) for that reason.
- The coupling is real: if the producer changes the backend location, every consumer breaks until
  updated. The validator exercised the live link by changing the producer's `bay_count` and
  re-applying; the timetable header followed.

Think of remote state as an interface contract between teams: stable file location, stable output
names, deliberate changes.
