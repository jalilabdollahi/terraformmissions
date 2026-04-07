# BUG: sum of minimums (2+2+2=6) exceeds length (5) — impossible to satisfy.

resource "random_password" "db_pass" {
  length      = 5
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  special     = false
}
