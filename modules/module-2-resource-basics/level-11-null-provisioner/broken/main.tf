# BUG: "echoo" is a typo — the correct command is "echo".

resource "null_resource" "greeting" {
  provisioner "local-exec" {
    command = "echoo hello"
  }
}
