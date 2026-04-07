# Variable Propagation Chain — Incident Post-Mortem

## The Incident
A variable was renamed from `token_size` → `token_length` across a 3-level module chain.
The rename was applied to the module variable declarations but NOT to the call sites:
1. Root still passed `token_size` to module_a (should be `token_length`)
2. Module_a still passed `string_length` to module_b (should be `token_length`)

## The Two Bugs
1. `main.tf` root: `token_size = 16` → `token_length = 16`
2. `modules/module_a/main.tf`: `string_length = var.token_length` → `token_length = var.token_length`

## Rename Chain Checklist
When renaming a variable across nested modules:
1. Rename the `variable` declaration in the innermost module
2. Update all `module.<name>.<var>` call sites that pass to that module
3. Rename the variable in intermediate modules
4. Update call sites for intermediate modules
5. Update the root call site last
6. `terraform validate` at each level before moving up

## Tooling Help
```bash
# Find all references to the old variable name
grep -r "token_size" .
grep -r "string_length" .

# After fix, verify no old names remain
grep -r "token_size" . && echo "STILL REFERENCES OLD NAME"
```

## Key Takeaway
Variable renames in nested module chains require updating BOTH the declaration AND every
call site. Use grep to find all references before declaring the rename complete.