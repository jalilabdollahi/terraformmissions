# Walkthrough - Antenna Time Console

1. `terraform validate` already reports `Duplicate object key` for `per_family`. Note it and move on to the silent bug.
2. Open the console (it reads your config without touching infrastructure):
   ```bash
   terraform console
   > local.usable
   > local.ranked
   > local.top_minutes
   ```
   `local.ranked` is `["9", "88", "7", "15", "120"]` - strings ordered alphabetically, so the "longest" three are wrong.
3. Try the fix in the console before editing:
   ```
   > reverse(sort([for p in local.usable : format("%05d|%s", tonumber(p.minutes), p.satellite)]))
   ```
   That returns zero-padded keys (`"00120|HERON-3"`, `"00088|OSPREY-5"`, ...) in the right order.
4. Replace `ranked`/`top_minutes`/`longest_windows` with the padded-key version and `split("|", k)[1]`.
5. Fix `per_family`: append `...` to the value expression (`=> tonumber(p.minutes)...`) so each key collects a list.
6. In the console check `local.per_family` shows `HERON = [120, 15]`, then `terraform apply` and `check`.
