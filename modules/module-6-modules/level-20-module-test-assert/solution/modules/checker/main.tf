resource "local_file" "result" {
  content  = "correct"
  filename = "${path.module}/result.txt"
}

output "result" {
  value = local_file.result.content
}
