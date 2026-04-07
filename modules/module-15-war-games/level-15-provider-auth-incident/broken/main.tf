# The local provider doesn't need auth, but this demonstrates the pattern.
# The broken terraform.tf references var.api_key which doesn't exist.
resource "local_file" "auth_test" {
  content  = "auth test passed"
  filename = "${path.module}/auth_test.txt"
}

output "auth_status" {
  value = "authenticated"
}
