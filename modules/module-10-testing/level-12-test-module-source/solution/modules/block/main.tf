variable "edge_cm" {
  description = "Finished edge of one square block."
  type        = number
  default     = 15
}

variable "block_count" {
  type    = number
  default = 12
}

output "fabric_cm2" {
  # one centimetre of seam allowance on every side
  value = (var.edge_cm + 2) * (var.edge_cm + 2) * var.block_count
}
