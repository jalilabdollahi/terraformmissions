resource "local_file" "motd" {
  content  = "Welcome to TerraformMissions!"
  filename = "${path.module}/motd.txt"
}
