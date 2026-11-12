# Walkthrough — Provenance Fingerprints

1. **Look at the shape of the state.**
   ```bash
   terraform state pull | jq 'keys'
   # ["lineage","outputs","resources","serial","terraform_version","version"]
   ```
2. **Read the two top-level fingerprints.**
   ```bash
   terraform state pull | jq -r .serial     # e.g. 4
   terraform state pull | jq -r .lineage    # a UUID
   ```
3. **Find the seal inside the resources.**
   ```bash
   terraform state pull | jq -r '.resources[] | select(.name == "lot_seal") | .instances[0].attributes.hex'
   ```
4. **Write the three answers.**
   ```bash
   mkdir -p answers
   terraform state pull | jq -r .serial  > answers/serial.txt
   terraform state pull | jq -r .lineage > answers/lineage.txt
   terraform state pull | jq -r '.resources[] | select(.name == "lot_seal") | .instances[0].attributes.hex' > answers/seal-hex.txt
   ```
5. Type `check`.
