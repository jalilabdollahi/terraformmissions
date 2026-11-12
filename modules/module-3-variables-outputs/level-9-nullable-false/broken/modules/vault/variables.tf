variable "vault_name" {
  description = "Label of the backup vault."
  type        = string
}

variable "retention_days" {
  description = "How many days snapshots are kept. Defaults to 30."
  type        = number
  default     = 30
}
