# Walkthrough: Piano Ticket Closing Line

1. **Validate.**
   ```
   Error: Invalid reference from destroy provisioner
   Destroy-time provisioners and their connection configurations may only reference attributes of the related
   resource, via 'self', 'count.index', or 'each.key'.
   ```
   The line number is the `closed ...` command.
2. **Compare with the create-time provisioner**, which already uses `self.input.ticket`.
3. **Why the restriction exists.** At destroy time the configuration may no longer contain other
   resources or even this resource's own block, so Terraform stores what the provisioner needs inside the
   resource itself: that is why the ticket lives in `input`.
4. **Fix.**
   ```hcl
   command = "mkdir -p visits && echo 'closed ${self.input.ticket}' >> visits/diary.log"
   ```
5. Apply, then `terraform apply -replace=terraform_data.tuning_ticket` to watch the log gain a `closed` line. Type `check`.
