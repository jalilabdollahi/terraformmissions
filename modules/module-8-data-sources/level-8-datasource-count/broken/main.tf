# count = 3 creates indices 0, 1, 2.
# The output references index [3] which does not exist.
# Fix: change [3] to a valid index like [0], [1], or [2].

data "local_file" "configs" {
  count    = 3
  filename = "${path.module}/config-${count.index}.txt"
}

output "first_config" {
  value = data.local_file.configs[3].content
}
