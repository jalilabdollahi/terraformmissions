variable "dishes" {
  type = list(string)
}

resource "local_file" "supper" {
  filename = "${path.root}/menu/supper.txt"
  content  = join("\n", [for i, d in var.dishes : "${i + 1}. ${d}"])
}

output "course_count" {
  value = length(var.dishes)
}
