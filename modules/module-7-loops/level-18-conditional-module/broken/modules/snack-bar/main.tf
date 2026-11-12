resource "local_file" "menu" {
  filename = "${var.output_dir}/snacks.txt"
  content  = join("\n", concat(["SNACK BAR MENU"], [for i in var.items : "- ${i}"], [""]))
}
