resource "null_resource" "deploy" {
  triggers = {
    version = "1"
  }
}
