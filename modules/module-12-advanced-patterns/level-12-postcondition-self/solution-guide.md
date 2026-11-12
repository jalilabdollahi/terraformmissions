# Walkthrough: Varnish Batch Guard

1. **Validate.**
   ```
   Error: Invalid reference in postcondition
     on main.tf line 28, in resource "terraform_data" "varnish_batch":
   Configuration for terraform_data.varnish_batch may not refer to itself.
   ```
   You get one error per condition.
2. **Why.** A postcondition runs after the object exists. Naming `terraform_data.varnish_batch`
   inside its own block would make the resource depend on itself.
3. **Use `self`.**
   ```hcl
   condition = self.output.litres <= 5
   condition = self.output.cure_days >= 5
   ```
   `self` is only valid in `postcondition` blocks (and provisioners); it holds the values of the object just applied.
4. Apply: the plan creates the batch record and the label file. Type `check`.
