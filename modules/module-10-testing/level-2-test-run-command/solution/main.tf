resource "local_file" "config" {
  content  = "configured"
  filename = "${path.module}/config.txt"
}

output "status" {
  value = "configured"
}
