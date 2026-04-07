variable "files" {
  type = map(string)
  default = {
    alpha = "content-alpha"
    beta  = "content-beta"
  }
}

resource "local_file" "docs" {
  for_each = var.files
  content  = each.value
  filename = "${path.module}/${each.key}.txt"
}

output "files" {
  value = { for k, v in local_file.docs : k => v }
}
