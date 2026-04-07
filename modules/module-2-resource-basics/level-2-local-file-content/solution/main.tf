resource "local_file" "readme" {
  content  = "Hello, Terraform!"
  filename = "${path.module}/readme.txt"
}
