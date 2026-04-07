# The test expects a local_file.manifest resource and output.manifest_path,
# but they are not defined here.

resource "local_file" "config" {
  content  = "base config"
  filename = "${path.module}/config.txt"
}

output "config_path" {
  value = local_file.config.filename
}
