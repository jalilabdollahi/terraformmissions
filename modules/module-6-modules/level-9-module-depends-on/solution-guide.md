# Walkthrough — Zamboni Waits For Ice

1. **Reproduce on a clean checkout.** Make sure `rink/` does not exist and run `terraform plan`:
   ```
   Error: Read local file data source ... open ./rink/ice-log.txt: no such file or directory
     with module.resurfacer.data.local_file.ice_log
   ```
2. **Find the missing edge.** `log_path` is a literal string, so nothing in the graph links the chiller's
   `local_file.ice_log` to the resurfacer's `data.local_file.ice_log`. Data sources are read at plan time
   unless they depend on something with pending changes.
3. **Declare the dependency.**
   ```hcl
   module "resurfacer" {
     ...
     depends_on = [module.chiller]
   }
   ```
4. With `depends_on` the data read is deferred until the chiller has applied, so the first apply works and a
   thickness change is visible in the same run. Apply with `-var thickness_mm=30` to see 60. Then `check`.
