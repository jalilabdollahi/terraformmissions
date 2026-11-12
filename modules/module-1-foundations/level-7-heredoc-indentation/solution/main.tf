# Chalkboard menu for the Copper Kettle tavern, written to a file the
# front-of-house tablet reads. The tablet does not trim whitespace.
variable "soup" {
  type    = string
  default = "leek and barley"
}

resource "local_file" "menu_board" {
  filename = "${path.module}/tavern/menu.txt"
  content  = <<-EOT
    Tonight at the Copper Kettle
      - Soup: ${var.soup}
      - Roast pheasant, juniper jus
      - Treacle tart
    Kitchen closes at 21:30
    EOT
}

output "menu_lines" {
  value = length(split("\n", trimspace(local_file.menu_board.content)))
}
