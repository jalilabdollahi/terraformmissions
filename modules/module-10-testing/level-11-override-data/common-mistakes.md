# Common mistakes

- **Creating `sensor/wind-knots.txt`.** That makes the test depend on a file in the repo; the mission explicitly forbids it, and the other scenarios would still need different readings.
- **Changing the thresholds in `festival.tf` to match the broken readings.** The code is correct; the mutation check changes the threshold in a copy and expects failures.
- **Using `override_resource` for the data source.** It is rejected: "You can only target resources from override_resource blocks". Use `override_data`.
- **Setting `content = 34` as a number.** It converts to a string and works, but a typo in the key name is what breaks things, so check names first.
