# Street-food rally: one trading permit per truck.

resource "local_file" "permit" {
  count    = length(var.trucks)
  filename = "${path.module}/permits/${var.trucks[count.index]}.txt"
  content  = "Trading permit for ${var.trucks[count.index]} - pitch ${count.index + 1}\n"
}

# Council portal expects a list with the path of every permit.
output "permit_paths" {
  value = local_file.permit[0].filename
}

output "permit_count" {
  value = length(local_file.permit)
}
