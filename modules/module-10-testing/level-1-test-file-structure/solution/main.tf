resource "local_file" "hello" {
  content  = "hello"
  filename = "${path.module}/hello.txt"
}

output "greeting" {
  value = "hello"
}
