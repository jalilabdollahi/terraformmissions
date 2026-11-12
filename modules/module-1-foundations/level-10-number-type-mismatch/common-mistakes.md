# Common mistakes

- **Changing the variable type to `string`.** The default now validates, but `team_count` would be the
  text "eight", not 8, and the mission expects the number.
- **Fixing only the variable.** The `result_count` error remains; there are two separate spots.
- **Using `tonumber("eight")`.** The function cannot parse words either and fails at plan time.
- **Deleting `result_count`.** The default of one question per shuffle is not what the quiz needs.
