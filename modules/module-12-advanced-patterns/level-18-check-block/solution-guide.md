# Walkthrough: Turbidity Sensor Warning

1. **Plan.**
   ```
   Error: Resource precondition failed
     Clarifier 4 turbidity sensor is not reporting ok.
   ```
   The plant's rule is blocking the shift report.
2. **Choose the right tool.** Rules that must *prevent* a change are conditions. Rules that *tell you
   something is off* are checks.
3. **Rewrite.** Move the data source inside a `check` block and use `assert`:
   ```hcl
   check "clarifier_sensor" {
     data "local_file" "sensor" { filename = "${path.module}/clarifier/status.txt" }
     assert {
       condition     = trimspace(data.local_file.sensor.content) == "ok"
       error_message = "Clarifier 4 turbidity sensor is not reporting ok."
     }
   }
   ```
   Remove the `lifecycle` block from the report resource.
4. **Apply.** The report is created and the output ends with
   `Warning: Check block assertion failed ... status not ok`. Type `check`.
