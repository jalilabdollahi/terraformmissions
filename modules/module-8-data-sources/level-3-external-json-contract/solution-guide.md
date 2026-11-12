# Walkthrough — Balloon Basket Manifest

1. **Diagnose.** `terraform plan` fails in `data.external.load` with a message like
   `command "python3" produced invalid JSON ... cannot unmarshal number into Go value of type string`
   (or `object` / `array`). Running `python3 bin/manifest.py` shows the offending output:
   `"pax": 4`, `"names": [...]`, `"limits": {...}`.
2. **Understand the contract.** The `external` data source parses the program's stdout as one flat
   JSON object, string keys to string values. Numbers, lists, booleans and nested objects are all
   rejected.
3. **Fix the script.** Convert everything to strings; encode the list as a delimited string and
   flatten the nested limit. `main.tf` expects `names` split on `|` and a top-level `max_kg`.
   ```python
   result = {
       "pilot": "Hester Marl",
       "pax": str(len(rows)),
       "total_kg": str(sum(int(r["weight_kg"]) for r in rows)),
       "names": "|".join(r["name"] for r in rows),
       "max_kg": "360",
   }
   ```
4. `terraform apply` and read the outputs: `total_kg = 303`, `headroom_kg = 57`. Type `check`.
