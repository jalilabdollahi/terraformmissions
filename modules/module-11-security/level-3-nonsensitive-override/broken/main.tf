variable "secret" {
  type      = string
  sensitive = true
  default   = "top-secret-value"
}

# Broken: nonsensitive() directly on a sensitive variable exposes it
output "exposed_secret" {
  value = nonsensitive(var.secret)
}
