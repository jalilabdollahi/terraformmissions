resource "random_string" "password" {
  length           = 12
  special          = true
  override_special = "!@#$%"
}
