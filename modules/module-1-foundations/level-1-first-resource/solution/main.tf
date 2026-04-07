resource "local_file" "greeting" {
  content  = "Hello, TerraformMissions!"
  filename = "${path.module}/greeting.txt"
}
