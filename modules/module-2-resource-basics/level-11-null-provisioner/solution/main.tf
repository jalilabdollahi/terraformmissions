resource "null_resource" "greeting" {
  provisioner "local-exec" {
    command = "echo hello"
  }
}
