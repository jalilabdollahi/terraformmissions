resource "local_file" "b_config" {
  content  = "module b config"
  filename = "${path.module}/b_config.txt"
}
