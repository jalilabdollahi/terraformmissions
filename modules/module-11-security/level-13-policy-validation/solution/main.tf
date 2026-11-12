# VPN gateway settings for the Saint Odran scriptorium, where the monks scan manuscripts
# to the diocesan archive. Security policy: only internal networks, modern TLS only.
variable "allowed_cidrs" {
  type        = list(string)
  description = "networks allowed to reach the archive gateway"
  default     = ["10.30.0.0/16", "192.168.40.0/24"]

  validation {
    condition     = length(var.allowed_cidrs) > 0 && alltrue([for c in var.allowed_cidrs : can(cidrhost(c, 0)) ? tonumber(split("/", c)[1]) >= 8 : false])
    error_message = "allowed_cidrs must be a non-empty list of valid networks, none broader than a /8, never 0.0.0.0/0 or ::/0."
  }
}

variable "min_tls_version" {
  type    = string
  default = "1.2"

  validation {
    condition     = contains(["1.2", "1.3"], var.min_tls_version)
    error_message = "min_tls_version must be 1.2 or 1.3."
  }
}

resource "local_file" "gateway_conf" {
  filename = "${path.module}/gateway/archive-vpn.conf"
  content  = <<-EOT
    tls_min_version = ${var.min_tls_version}
    %{ for c in var.allowed_cidrs ~}
    allow ${c}
    %{ endfor ~}
    default deny
  EOT
}

output "allowed_count" {
  value = length(var.allowed_cidrs)
}
