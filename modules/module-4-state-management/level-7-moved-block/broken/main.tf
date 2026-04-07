# The resource was renamed from "old_name" to "new_name" in the config,
# but no moved {} block was added. Without it, Terraform plans a destroy+create.
# BUG: missing moved {} block

resource "local_file" "new_name" {
  content  = "managed file content"
  filename = "${path.module}/managed.txt"
}
