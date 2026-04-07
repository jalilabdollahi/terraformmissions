# Fix the syntax error in this resource block.

resource "local_file" "greeting" {
  content  = "Hello, TerraformMissions!"
  filename = "${path.module}/greeting.txt"
  # Missing closing brace below — the block is not closed
