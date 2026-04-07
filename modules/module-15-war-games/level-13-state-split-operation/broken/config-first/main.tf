# Resources 1-3 remain here.
# Resources 4-5 are being split out to config-second.
# Missing: moved blocks to record that res_4 and res_5 are leaving this config.
# Without them, Terraform plans to destroy res_4 and res_5 here.

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
