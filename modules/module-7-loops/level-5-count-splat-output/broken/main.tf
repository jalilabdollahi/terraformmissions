# Film shoots: one street-closure permit per production.

resource "local_file" "closure" {
  count    = length(var.shoots)
  filename = "${path.module}/closures/${var.shoots[count.index]}.txt"
  content  = "Street-closure permit for ${var.shoots[count.index]} - slot ${count.index + 1}\n"
}

# Film office portal expects a list with the path of every closure permit.
output "closure_paths" {
  value = local_file.closure[0].filename
}

output "closure_count" {
  value = length(local_file.closure)
}
