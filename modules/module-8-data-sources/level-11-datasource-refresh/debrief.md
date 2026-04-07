# Stale Data Source

## What Was Broken
The output referenced `content_base64` instead of `content`. After apply, the output showed
Base64-encoded text instead of the human-readable file content.

## The Fix
```hcl
output "file_text" {
  value = data.local_file.reader.content
}
```

## terraform plan -refresh-only
The `-refresh-only` flag tells Terraform to update its state to reflect the real current state
of infrastructure **without** making any changes. This is useful for detecting drift between
the state file and the actual system.

```bash
terraform plan -refresh-only     # what has changed outside of Terraform?
terraform apply -refresh-only    # accept the drift into the state file
```

## Key Takeaway
Use `content` for UTF-8 text files. Use `content_base64` for binary files or when you need
to pass the content to another resource that expects Base64 encoding.