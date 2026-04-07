module "hello" {
  source = "./modules/hello"
}

# This resource depends on a module that doesn't exist.
resource "local_file" "note" {
  content  = "dependency test"
  filename = "${path.module}/note.txt"
  depends_on = [module.nonexistent]
}
