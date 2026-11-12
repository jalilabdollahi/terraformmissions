# Walkthrough — Bell Tower Peal Order

1. `terraform plan` ends with `Call to function "index" failed: item not found.` and points at
   `local.start_index`. `start_bell` defaults to `Michael`.
2. Confirm in `terraform console`:
   ```
   > index(["Gabriel","Mary"], "Mary")        # 1
   > index(["Gabriel","Mary"], "Michael")     # error
   > contains(["Gabriel","Mary"], "Michael")  # false
   ```
3. Guard it: `contains(var.bells, var.start_bell) ? index(var.bells, var.start_bell) : 0`. The `concat`
   of two `slice` calls then yields tower order when the index is 0.
4. Apply, then run `check`. The validator also tries `Peter` and an unknown name on another tower.
