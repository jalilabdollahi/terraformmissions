resource "local_file" "output" {
  content  = var.content
  filename = "${path.module}/../../output/${var.basename}.txt"
}

# The output was renamed from "file_path" to "filename" in this module version.
output "filename" {
  value = local_file.output.filename
}
