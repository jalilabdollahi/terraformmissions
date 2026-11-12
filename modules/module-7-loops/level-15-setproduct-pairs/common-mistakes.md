# Common mistakes

- **Using `toset(setproduct(...))`.** A set of tuples is still not a set of strings, so for_each still
  rejects it.
- **Using `count = length(local.room_days)` with `local.room_days[count.index]`.** It plans, but the
  addresses are positions and adding a day renumbers the bookings.
- **Choosing a key that is not unique, such as `pair[0]`.** Keys collide ("Duplicate object key") because
  each room appears twice.
- **Joining with `-` and also changing the file naming.** The file name is `<room>-<day>.txt` and the
  validator checks exact keys of the form room/day.
