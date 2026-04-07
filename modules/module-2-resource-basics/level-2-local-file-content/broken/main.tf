# BUG: content_base64 expects a valid base64-encoded string, not plain text.
# Using a plain string here causes an apply-time error.

resource "local_file" "readme" {
  content_base64 = "Hello, Terraform!"
  filename       = "${path.module}/readme.txt"
}
