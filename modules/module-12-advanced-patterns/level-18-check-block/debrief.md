# Debrief: conditions stop, checks tell

Terraform has two families of custom assertions. Preconditions and postconditions are attached to a resource, data
source or output and are **errors**: when they fail, the run stops for that object and everything depending on
it. They protect invariants such as "this size is allowed" or "the AMI is the right architecture".

A `check` block is a top-level assertion about the infrastructure as a whole, and failures are **warnings**.
The plan and apply continue, and the warning is printed at the end. That makes checks the right fit for
health and drift information: "the sensor says degraded", "the certificate expires in 10 days", "the endpoint returns 200".
These things change without any Terraform change and should not block unrelated work.

A check may contain a **scoped data source**, declared inside the block and visible only to its assertions.
The advantage is isolation: if the read itself fails (a timeout, a missing file) Terraform reports that as a
failed check too, and not as an error that kills the plan.

In the level a precondition mixed two concerns: refusing to write the report, and telling people about the sensor. Splitting
them gives you both a report that is always written and a visible warning on every plan until someone fixes the sensor.

Real-world takeaway: use `precondition` for "must be true to proceed" and `check` for "should be true, tell me if not".
