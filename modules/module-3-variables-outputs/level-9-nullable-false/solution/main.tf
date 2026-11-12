# Deepfreeze Backups — vault policy generator.
# Teams may override the retention period from their pipeline; most don't, and
# the pipeline then passes an unset (null) variable through to the vault module.

variable "retention_override" {
  description = "Optional retention override in days; leave unset to use the vault default."
  type        = number
  default     = null
}

module "vault" {
  source = "./modules/vault"

  vault_name     = "cold-archive"
  retention_days = var.retention_override
}

output "effective_retention" {
  value = module.vault.retention_days
}
