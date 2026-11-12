# Walkthrough — Wax And Groove Prices

1. **Run `terraform validate`.** The first error is on line 1:
   ```
   Error: Argument or block definition required
     on main.tf line 1:
      1: -- Price list for Wax & Groove Records ...
   An argument or block definition is required here.
   ```
   Later errors (the `;` line and the `<!--` block) are separate problems of the same kind.
2. **Know the comment syntax.** `# like this`, `// or this`, and `/* a block
   that spans lines */`.
3. **Convert all three.** `--` becomes `#`; `;` becomes `#`; the `<!-- ... -->` note becomes `/* ... */`.
4. **Validate and apply.** `shop/price-list.csv` now has three priced lines.
