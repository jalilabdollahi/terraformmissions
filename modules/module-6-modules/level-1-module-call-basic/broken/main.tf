# The module source path is wrong — it points one directory UP, not into modules/hello.
module "hello" {
  source = "../hello"
}
