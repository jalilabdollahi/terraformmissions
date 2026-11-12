# Walkthrough — Lockgate Toll Ledger

1. **Run the plan.**
   ```
   Error: Missing required argument
     on main.tf line 11, in module "lockgate":
   The argument "beam_m" is required, but no definition was found.
   ```
2. **Compare caller and callee.** The module declares `canal`, `length_m` and `beam_m` without defaults.
   The call passes `canal` and `length_m`.
3. **Pass the missing input from the root variable.**
   ```hcl
   beam_m = var.vessel_beam_m
   ```
4. `terraform apply` — `toll_pence` is `4 * 1000 + 18 * 250 = 8500`. Then `check`.
