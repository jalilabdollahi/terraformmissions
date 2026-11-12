# Walkthrough — Skerry Head Instrument Roster

1. `terraform plan` fails: `This object does not have an attribute named "instruments"`. The YAML
   nests everything under `observatory:`, so the path is `local.cfg.observatory.instruments`.
2. After fixing the path, apply and read `roster/instruments.txt`. It says `fw 2.1` and `lang false`.
3. Look at what YAML made of those values in `terraform console`:
   ```
   > yamldecode("language: no")        # { language = false }
   > yamldecode("firmware: 2.10")      # { firmware = 2.1 }
   > yamldecode("firmware: \"2.10\"")  # { firmware = "2.10" }
   ```
4. Quote the values in `config.yaml` (`firmware: "2.10"`, `language: "no"`, `language: "off"`).
   Changing the Terraform side cannot recover information the parser already threw away.
5. Apply, run `check`.
