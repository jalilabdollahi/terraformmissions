resource "random_password" "audit_key" {
  length  = 24
  special = false
}

resource "local_sensitive_file" "audit_credential" {
  content         = random_password.audit_key.result
  filename        = "${path.module}/audit.key"
  file_permission = "0600"

  lifecycle {
    postcondition {
      # Broken: checks for 0644 but the resource creates with 0600
      condition     = self.file_permission == "0644"
      error_message = "Audit credential file must have restrictive permissions."
    }
  }
}
