resource "local_file" "readme" {
  content  = "Hello from Terraform!"
  filename = "${path.module}/README.txt"
}
