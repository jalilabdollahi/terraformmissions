# Starlight Roller Disco: the snack bar is only staffed on session nights.
# Its menu lives in a small local module that is switched on with count.

module "snack_bar" {
  source     = "./modules/snack-bar"
  count      = var.snack_bar_open ? 1 : 0
  output_dir = "${path.module}/menus"
  items      = var.snack_items
}

output "menu_path" {
  description = "Path of the printed menu, or null when the snack bar is closed."
  value       = one(module.snack_bar[*].menu_path)
}

output "menu_items" {
  description = "Items on the menu, or an empty list when the snack bar is closed."
  value       = flatten(module.snack_bar[*].items)
}
