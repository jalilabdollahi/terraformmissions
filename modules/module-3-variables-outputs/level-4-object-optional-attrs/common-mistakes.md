# Common mistakes

- **Adding `size = "regular"` to the two tfvars entries.** The error goes away, but the data is the
  input, and the next entry without a size fails again. The mission checks a brand-new entry too.
- **Using `optional(string)` with no default.** The attribute becomes `null`, and till/menu.json then
  contains `"size": null` entries.
- **Making the whole variable `type = any`.** That drops all validation, including typos in `price`.
- **Using `try(d.size, "regular")` in the locals.** With a strict object type the error happens during
  type conversion, before the local is evaluated, so `try` never gets a chance.
