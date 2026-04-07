resource "local_file" "a_config" {
  content  = "module a config"
  filename = "${path.module}/a_config.txt"
}
