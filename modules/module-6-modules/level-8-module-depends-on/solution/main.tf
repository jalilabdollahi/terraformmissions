module "hello" {
  source = "./modules/hello"
}

resource "local_file" "note" {
  content  = "dependency test"
  filename = "${path.module}/note.txt"
  depends_on = [module.hello]
}
