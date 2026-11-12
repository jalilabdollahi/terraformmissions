# Common mistakes

- **Renaming the resource block to `room_no`.** That makes the plan error go away, but the board and the rest of the code still refer to `room_number`, and the mission requires that address.
- **Leaving `1` as the minimum.** The import works and then the plan says "must be replaced": the imported object's `min` differs from the code.
- **Running `terraform plan` and expecting state to change.** Imports are only planned; `terraform apply` performs them.
- **Changing `min`/`max` in the resource block to match the ID.** The pool is 100 to 999; changing the code to match a wrong ID hides the real mismatch.
- **Importing the room with the `terraform import` command.** It works, but this mission requires the declarative import block to remain in the config.
