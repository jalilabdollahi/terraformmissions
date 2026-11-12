# Dunlin Field tower logbook: entries are signed with a secret kept in a key file.
# The file mode is set by var.key_mode, and an audit step reads the REAL mode from disk
# after the file exists (the audit script reports it as octal digits, e.g. "644").
variable "key_mode" {
  type    = string
  default = "0644"
}

resource "random_password" "logbook_signing" {
  length  = 40
  special = false
}

resource "local_sensitive_file" "logbook_key" {
  filename        = "${path.module}/tower/logbook-signing.key"
  content         = "${random_password.logbook_signing.result}\n"
  file_permission = var.key_mode
}

data "external" "key_audit" {
  program    = ["python3", "${path.module}/bin/audit_mode.py"]
  query      = { path = local_sensitive_file.logbook_key.filename }
  depends_on = [local_sensitive_file.logbook_key]

  lifecycle {
    postcondition {
      condition     = self.result.exists == "true"
      error_message = "The logbook signing key does not meet policy: it must exist and be readable by its owner only."
    }
  }
}

output "audited_mode" {
  value = data.external.key_audit.result.mode
}
