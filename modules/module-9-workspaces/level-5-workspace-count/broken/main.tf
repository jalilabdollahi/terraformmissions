# "workspace" alone is not a valid reference — it needs the terraform. prefix.
# Fix: change workspace == "default" to terraform.workspace == "default"

resource "local_file" "optional" {
  count    = workspace == "default" ? 1 : 0
  content  = "only in default workspace"
  filename = "${path.module}/default-only.txt"
}
