# Ferrous Bay robot warehouse: robot controller credentials.
# imports.tf already points at three live objects.

resource "random_string" "aisle_label" {
  length      = 8
  lower       = true
  min_lower   = 0
  min_numeric = 0
  min_special = 0
  min_upper   = 0
  numeric     = true
  special     = true
  upper       = true
}

resource "random_password" "charging_pin" {
  length      = 12
  lower       = true
  min_lower   = 0
  min_numeric = 0
  min_special = 0
  min_upper   = 0
  numeric     = true
  special     = true
  upper       = true
}

resource "random_integer" "picking_zone" {
  max = 64
  min = 1
}
