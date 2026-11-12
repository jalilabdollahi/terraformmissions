# Telemetry credentials for the Hollowmere vending-machine fleet.
# The machines' sync agent refuses to start if the token file is readable by
# anyone but its owner, and the manifest must stay world-readable for the
# depot's inventory scanner.

variable "depot_token" {
  type      = string
  default   = "vm-tok-7f3a91c2d8"
  sensitive = true
}

resource "local_sensitive_file" "sync_token" {
  filename             = "${path.module}/fleet/sync.token"
  content              = var.depot_token
  file_permission      = "0600"
  directory_permission = "0755"
}

resource "local_file" "machine_manifest" {
  filename        = "${path.module}/fleet/machines.csv"
  content         = "id,site\nVM-001,Harbor Rd\nVM-002,Depot Gate\nVM-003,Station Hall\n"
  file_permission = "0644"
}

output "token_path" {
  value = local_sensitive_file.sync_token.filename
}
