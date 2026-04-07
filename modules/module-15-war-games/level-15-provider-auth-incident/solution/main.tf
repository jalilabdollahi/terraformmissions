resource "local_file" "auth_test" {
  content  = "auth test passed"
  filename = "${path.module}/auth_test.txt"
}

output "auth_status" {
  value = "authenticated"
}
