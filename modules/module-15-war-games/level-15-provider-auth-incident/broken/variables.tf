# The credential variable is named api_secret, NOT api_key.
variable "api_secret" {
  type      = string
  sensitive = true
  default   = "dummy-secret-for-local-provider"
}
