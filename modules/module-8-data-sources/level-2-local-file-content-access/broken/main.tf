# The output uses the wrong attribute — content_base64 returns Base64, not plain text.
# Fix: change content_base64 to content

data "local_file" "readme" {
  filename = "${path.module}/readme.txt"
}

output "readme_text" {
  value = data.local_file.readme.content_base64
}
