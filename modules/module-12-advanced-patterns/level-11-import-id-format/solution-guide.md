# Walkthrough: Numbered, Launched And Corked

1. **Plan.** Three different symptoms:
   - `random_integer.bottle`: `Error: Import Random Integer Error ... expecting {result},{min},{max}`.
   - `time_static.launch`: `Error: Import time static error: The id that was supplied could not be parsed as RFC3339`.
   - `random_id.cork`: it plans a replacement, because the hex string was decoded as a 6-byte value while
     the resource says `byte_length = 4`.
2. **Look up each format** (provider docs, import section) and match it to `bottle-register.csv`.
3. **Fix the three IDs.**
   ```hcl
   id = "212,100,999"
   id = "2025-04-12T06:30:00Z"
   id = "Yd4Pxg"
   ```
4. **Plan.** `Plan: 3 to import, 1 to add, 0 to change, 0 to destroy` (the certificate file is the one addition).
   Apply, then `check`.
