# Each trading post on the Salt Road gets a wax-seal token. The ledger keeps one file per post.
variable "post_names" {
  type        = set(string)
  description = "names of the trading posts (not secret)"
  default     = ["petra", "merv", "palmyra"]
}

variable "seal_tokens" {
  type        = map(string)
  sensitive   = true
  description = "trading post name => seal token"
}

resource "local_sensitive_file" "seal" {
  for_each        = var.post_names
  filename        = "${path.module}/seals/${each.key}.seal"
  content         = var.seal_tokens[each.key]
  file_permission = "0600"
}

output "post_count" {
  value = length(var.post_names)
}

output "seal_digests" {
  value     = { for post in var.post_names : post => sha256(var.seal_tokens[post]) }
  sensitive = true
}
