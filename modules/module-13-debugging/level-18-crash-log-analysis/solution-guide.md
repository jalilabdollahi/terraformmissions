# Walkthrough - Diamond Mine Crash Log

1. Open `crash.log`. Skip the INFO/TRACE preamble and find the first line that is not a log line: `panic: interface conversion:
   interface {} is map[string]interface {}, not string`. A Go panic means the *plugin* crashed, not Terraform core.
2. Read the stack: the top frame is `terraform-provider-external ... (*externalDataSource).Read`. The log lines just before it say
   `Calling data source: tf_data_source_type=external` and `Decoding program result into map[string]string`.
3. Terraform's own error blocks at the end give you the address (`with data.external.shaft_scan`) and say the crash happened while decoding
   the key `"readings"`, which held a JSON object.
4. The WARN about `sensitive_content` on `local_file` is noise: it is a deprecation notice, not part of the crash.
5. Check the cause in the repo: `scripts/probe.py` prints `"readings": {"top": 12, ...}`, a nested object. The external data source's contract is a flat
   JSON object of strings.
6. Work around it: make the script emit `"readings"` as a JSON string (`json.dumps({...})`) and decode it in Terraform with `jsondecode(...)`.
7. Write the answers file:
   ```
   crashed_resource=data.external.shaft_scan
   offending_key=readings
   ```
8. `terraform apply`, then `check`.
