# Common mistakes

- **Running `terraform apply` immediately.** It rewrites the file with 1260 °C / 25 min and destroys the technician's fix.
- **Editing kiln/firing-schedule.txt back by hand.** That is the same as reverting the technician; the mission wants the values kept.
- **Changing the config but not applying.** The plan then still says one resource will be added, so it is not clean.
- **Changing only one of the two values.** The temperature and the hold time were both edited; compare the whole file line by line.
- **Using `-refresh-only` apply and stopping there.** It accepts the "deletion" into state, so the resource disappears from state and the plan wants to create it again.
