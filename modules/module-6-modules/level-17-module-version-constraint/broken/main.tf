# This Git source doesn't exist — init will fail.
module "data" {
  source = "git::https://example-internal.invalid/terraform-modules/data.git"
}
