# Common mistakes

- **Removing `keepers` altogether.** The combination becomes stable but the ticket no longer rotates it; the validator raises the ticket and expects a new password.
- **Using a constant keeper such as `ticket = "RIG-100"`.** Stable, but raising `rotation_ticket` changes nothing.
- **Switching to `uuid()` or `plantimestamp()`.** Both move on every evaluation (plantimestamp per plan), so the password rotates constantly.
- **Replacing the resource by hand with `terraform apply -replace` each time.** It works once but is not controlled by the ticket variable, and it is easy to forget in a pipeline.
