# Typo: "prodution" should be "production" (missing the letter 'c').
# Fix: correct the workspace name in the condition.

resource "local_file" "config" {
  count    = terraform.workspace == "prodution" ? 2 : 1
  content  = "instance ${count.index}"
  filename = "${path.module}/config-${count.index}.txt"
}

output "instance_count" {
  value = length(local_file.config)
}
