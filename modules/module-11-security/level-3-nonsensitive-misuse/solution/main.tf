variable "alarm_code" {
  type      = string
  sensitive = true
}

variable "vineyard" {
  type    = string
  default = "Sunnyslope Terraces"
}

locals {
  # The length of a code is not the code. This is the one thing the crew may see.
  alarm_code_length = nonsensitive(length(var.alarm_code))
}

resource "local_file" "frost_panel" {
  filename = "${path.module}/panel/frost-alarm.txt"
  content  = <<-EOT
    Vineyard: ${var.vineyard}
    Frost alarm armed: yes
    Code length: ${local.alarm_code_length} characters
  EOT
}

output "alarm_code" {
  value     = var.alarm_code
  sensitive = true
}

output "code_length" {
  value = local.alarm_code_length
}
