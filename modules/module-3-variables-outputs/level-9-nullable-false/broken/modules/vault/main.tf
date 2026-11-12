resource "local_file" "policy" {
  filename = "${path.root}/policies/${var.vault_name}.txt"
  content  = "${var.vault_name} keeps snapshots for ${var.retention_days} days\n"
}

output "retention_days" {
  value = var.retention_days
}
