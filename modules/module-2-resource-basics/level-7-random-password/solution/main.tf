resource "random_password" "db_pass" {
  length      = 10
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  special     = false
}
