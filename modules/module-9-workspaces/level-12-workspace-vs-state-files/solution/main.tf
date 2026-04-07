resource "local_file" "example" {
  content  = "workspace example"
  filename = "${path.module}/example.txt"
}
