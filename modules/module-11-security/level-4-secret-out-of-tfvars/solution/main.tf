variable "band_name" {
  type = string
}

variable "ticket_price_pence" {
  type = number
}

variable "gateway_api_key" {
  type      = string
  sensitive = true
}

resource "local_file" "ticket_desk" {
  filename = "${path.module}/box-office/ticket-desk.txt"
  content  = "${var.band_name} - ticket price: ${format("%.2f", var.ticket_price_pence / 100)} GBP\n"
}

resource "local_sensitive_file" "gateway_credentials" {
  filename        = "${path.module}/box-office/gateway.env"
  content         = "GATEWAY_KEY=${var.gateway_api_key}\n"
  file_permission = "0600"
}

output "key_hint" {
  value     = "ends in ${substr(var.gateway_api_key, length(var.gateway_api_key) - 4, 4)}"
  sensitive = true
}
