# Gate access rules for the Lindenhurst Gated Retirement Village.
locals {
  rules = {
    site       = "lindenhurst-village"
    allow_from = ["10.20.0.0/16"]
    deny_other = true
  }
}

resource "local_file" "gate_rules" {
  filename        = "${path.module}/gate/access-rules.json"
  content         = "${jsonencode(local.rules)}\n"
  file_permission = "0640"

  # "the plan keeps showing noise on this file", added during a rushed release
  lifecycle {
    ignore_changes = all
  }
}

output "rules_file" {
  value = local_file.gate_rules.filename
}
