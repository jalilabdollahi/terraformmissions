resource "local_file" "output" {
  content  = var.content
  filename = "${path.module}/../../output/${var.basename}.txt"
}

output "filename" {
  value = local_file.output.filename
}
