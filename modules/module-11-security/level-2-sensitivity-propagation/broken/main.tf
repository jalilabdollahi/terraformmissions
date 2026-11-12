# Each trading post on the Salt Road gets a wax-seal token. The ledger keeps one file per post.
variable "trading_posts" {
  type        = map(string)
  sensitive   = true
  description = "trading post name => seal token"
}

resource "local_sensitive_file" "seal" {
  for_each        = var.trading_posts
  filename        = "${path.module}/seals/${each.key}.seal"
  content         = each.value
  file_permission = "0600"
}

output "post_count" {
  value = length(var.trading_posts)
}

output "seal_digests" {
  value = { for post, token in var.trading_posts : post => sha256(token) }
}
