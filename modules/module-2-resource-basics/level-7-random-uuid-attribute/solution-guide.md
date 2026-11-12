# Solution guide

1. `terraform validate` reports `Unsupported attribute` : `This object has no argument, nested block,
   or exported attribute named "value"`, three times: in the ticket content (twice) and in the
   output.
2. `random_uuid` exports `result` (the UUID string) and `id`. There is no `value`. A habit from
   `terraform_data` or from other tools.
3. Replace `.value` with `.result` in all three places.
4. `terraform apply`; `cat lockers/ticket.json` shows both UUIDs.
