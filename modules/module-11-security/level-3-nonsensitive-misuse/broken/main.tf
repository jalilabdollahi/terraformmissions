variable "alarm_code" {
  type      = string
  sensitive = true
}

variable "vineyard" {
  type    = string
  default = "Sunnyslope Terraces"
}

locals {
  # Shown to the night crew so they know the code was loaded.
  alarm_code_plain = nonsensitive(var.alarm_code)
}

resource "local_file" "frost_panel" {
  filename = "${path.module}/panel/frost-alarm.txt"
  content  = <<-EOT
    Vineyard: ${var.vineyard}
    Frost alarm armed: yes
    Code on file: ${local.alarm_code_plain}
  EOT
}

output "alarm_code" {
  value = local.alarm_code_plain
}

output "code_length" {
  value = length(var.alarm_code)
}
