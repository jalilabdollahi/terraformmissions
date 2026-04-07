module "reader" {
  source   = "./modules/reader"
  filepath = "${path.module}/info.txt"
}

output "result" {
  value = module.reader.file_content
}
