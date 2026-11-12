resource "local_file" "colour_spec" {
  filename = "${path.root}/out/colour-spec.txt"
  content  = "Pigment load, ${var.pigment_pct} percent\n"
}

output "pigment_pct" {
  value = var.pigment_pct
}
