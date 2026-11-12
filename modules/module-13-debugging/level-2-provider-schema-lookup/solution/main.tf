# Garnet & Gold Couture House - archive-room door code and audit date.

resource "random_password" "door_code" {
  length  = 18
  special = false
}

resource "local_sensitive_file" "door_code_card" {
  filename        = "${path.module}/archive/door-code.txt"
  content         = random_password.door_code.result
  file_permission = "0600"
}

resource "time_offset" "next_audit" {
  base_rfc3339 = "2026-03-01T00:00:00Z"
  offset_days  = 30
}

output "audit_due" {
  value = time_offset.next_audit.rfc3339
}
