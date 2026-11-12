# Walkthrough — Kittiwake Crew Roster

1. `terraform plan` fails: `This object does not have an attribute named "crew"`. The YAML
   nests everything under `submarine:`, so the path is `local.cfg.submarine.crew`.
2. After fixing the path, apply and read `roster/crew.txt`. It says `manual 2.1` and `lang false`.
3. Look at what YAML made of those values in `terraform console`:
   ```
   > yamldecode("language: no")        # { language = false }
   > yamldecode("manual: 2.10")      # { manual = 2.1 }
   > yamldecode("manual: \"2.10\"")  # { manual = "2.10" }
   ```
4. Quote the values in `config.yaml` (`manual: "2.10"`, `language: "no"`, `language: "off"`).
   Changing the Terraform side cannot recover information the parser already threw away.
5. Apply, run `check`.
