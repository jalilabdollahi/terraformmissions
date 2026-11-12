# Walkthrough — Tool Library Rota

1. **First error.** `Unsupported attribute ... This object does not have an attribute named
   "state"`. In `library/stock.json` the field is `status`. Fix the condition: `if tool.status == "serviceable"`.
2. **Second error.** `Duplicate object key ... Two different items produced the key "garden"`. A
   `for` expression that builds an object needs unique keys. Because tools share a class, use
   grouping mode (`...`) after the value expression:
   ```hcl
   ready_by_class = { for tool in local.stock : tool.class => tool.id... if tool.status == "serviceable" }
   ```
   Each key now maps to a list of ids.
3. `terraform apply`. `terraform output ready_by_class` shows `garden = ["T-01","T-04"]` and
   `power =>= ["T-02","T-05"]`; `decor` is absent because its only tool is retired. Type `check`.
