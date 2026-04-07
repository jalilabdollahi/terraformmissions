data "local_file" "configs" {
  count    = 3
  filename = "${path.module}/config-${count.index}.txt"
}

output "first_config" {
  value = data.local_file.configs[0].content
}
