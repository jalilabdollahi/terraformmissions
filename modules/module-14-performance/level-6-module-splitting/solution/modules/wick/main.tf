resource "local_file" "wick_spec" {
  filename = "${path.root}/out/wick-spec.txt"
  content  = "Cotton wick, ${var.wick_cm} cm\n"
}

output "wick_cm" {
  value = var.wick_cm
}
