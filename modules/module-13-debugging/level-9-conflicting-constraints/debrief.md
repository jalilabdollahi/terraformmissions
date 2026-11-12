# Debrief - one provider version per configuration

A Terraform configuration, including every module it calls, installs **one** version of each provider. Constraints from the
root module and all child modules are intersected; if the intersection is empty, `terraform init` stops with
"no available releases match the given constraints" and lists every constraint it saw. That list is your diagnostic: it is
the whole conflict in one line.

Reading it takes two small skills. First, know the operators: `~> 2.3` is "2.3 or any later 2.x", never 3.0; `>= 3.5` has no
upper bound; `= 2.3.1` pins. Second, find the declarations: `grep -rn required_providers -A3 .` will show each module's
requirement, and `terraform providers` prints the tree of which module requires what.

Who should change? Rules of thumb:

- **Reusable modules** should state the *widest* range they were tested with (`>= 2.3, < 4.0`), not the single version their
  author happened to use. Overly tight module constraints are the most common cause of this error in shared module libraries.
- The **root module** owns the final decision and may narrow the range, never the other way round.
- Do not "fix" the conflict by lowering the root constraint just because it is the easiest edit; you would silently
  downgrade every other module as well.

Remember to verify the module really works on the newer major version (read its changelog); here `random_integer` is unchanged,
so only the constraint needed to move.
