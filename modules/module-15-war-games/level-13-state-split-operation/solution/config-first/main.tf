resource "random_string" "res_1" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "res_2" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "res_3" {
  length  = 8
  special = false
  upper   = false
}

# moved blocks recording that res_4 and res_5 have moved to config-second.
# These prevent destroy during the split operation.
moved {
  from = random_string.res_4
  to   = random_string.res_4
}

moved {
  from = random_string.res_5
  to   = random_string.res_5
}
