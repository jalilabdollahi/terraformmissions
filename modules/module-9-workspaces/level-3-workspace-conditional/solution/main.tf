resource "local_file" "config" {
  count    = terraform.workspace == "production" ? 2 : 1
  content  = "instance ${count.index}"
  filename = "${path.module}/config-${count.index}.txt"
}

output "instance_count" {
  value = length(local_file.config)
}
