# Walkthrough — Wrong Name On The Armoury Door

1. Reproduce what CI does:
   ```bash
   export TF_VAR_armoury_code=demo-not-a-real-secret-piste-4408 TF_VAR_club_region=severn-north
   export TF_VAR_squad_roster='["foil","epee","sabre"]'
   terraform plan
   ```
   Terraform asks for (or fails on) `ArmouryCode` and `club-region`. It only ever looks for `TF_VAR_ArmouryCode`
   and `TF_VAR_club-region`, and the second cannot be exported by a POSIX shell at all.
2. Rename `ArmouryCode` -> `armoury_code` and `club-region` -> `club_region` in the variable blocks **and** in
   the two resources.
3. `squad_roster` already matches, and shows that complex types work through the environment: Terraform parses the value as HCL/JSON.
4. Re-run the plan, then type `check`.
