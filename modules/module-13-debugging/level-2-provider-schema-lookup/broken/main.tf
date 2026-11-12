# Marsh Hollow wine cellar - door code and audit date.

resource "random_password" "door_code" {
  length        = 18
  special_chars = false
}

resource "local_sensitive_file" "door_code_card" {
  filename    = "${path.module}/cellar/door-code.txt"
  content     = random_password.door_code.result
  permissions = "0600"
}

resource "time_offset" "next_audit" {
  base_rfc3339 = "2026-03-01T00:00:00Z"
  days         = 30
}

output "audit_due" {
  value = time_offset.next_audit.rfc3339
}
