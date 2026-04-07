# State Corruption Recovery — Incident Post-Mortem

## The Incident
The `terraform.tfstate` file contained invalid JSON, likely caused by a process being killed
mid-write during a previous apply. Terraform uses atomic file writes in newer versions, but
older versions or interrupted applies on NFS/network filesystems can corrupt state.

## Recovery Procedure
1. **Check for backups** — Terraform creates `terraform.tfstate.backup` on each successful apply
2. **Validate the JSON** — `python3 -m json.tool terraform.tfstate` or `jq . terraform.tfstate`
3. **Attempt manual repair** — if the corruption is minor, fix the JSON manually
4. **Last resort: delete and reapply** — remove the state and apply fresh (causes resource recreation)

## Prevention
- **Use a remote backend** — S3, GCS, Azure Blob with versioning enabled; corrupt local state is unrecoverable
- **Enable state locking** — prevents concurrent writes that cause corruption (DynamoDB for S3 backend)
- **Regular state backups** — `terraform state pull > backup-$(date +%Y%m%d).tfstate`
- **Use Terraform Cloud/Enterprise** — managed state with automatic versioning and history

## State File Structure
```json
{
  "version": 4,        // state format version
  "serial": 3,         // incremented on each state write
  "lineage": "...",    // unique ID for this state lineage
  "outputs": {},       // output values
  "resources": []      // resource instances
}
```

## Key Takeaway
Never use local state backends in production. The moment the state file is corrupted or lost
on a local filesystem, you lose the relationship between Terraform config and real infrastructure.
Use a remote backend with versioning from day one.