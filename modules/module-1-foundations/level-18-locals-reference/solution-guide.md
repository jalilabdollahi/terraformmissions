# Walkthrough — Fenwick Cheese Cellar

1. **Run `terraform validate`.**
   ```
   Error: Unsupported block type
     on main.tf line 2:
      2: local {
   Blocks of type "local" are not expected here. Did you mean "locals"?
   ```
2. **Rename the block** to `locals {`. Validate again; now the references fail:
   ```
   Error: Reference to undeclared resource ... / Invalid reference
   ```
   because `locals.cheese` is read as "a resource of type `locals`".
3. **Use the singular prefix** everywhere: `local.cheese`, `local.rind`, `local.wheel_kg`, `local.wheel_price`.
4. **Compute the price.** Inside the `locals` block, a value may refer to the others:
   `wheel_price = local.wheel_kg * local.price_per_kg`.
5. **Apply** and check `cellar/wheel-label.txt`.
