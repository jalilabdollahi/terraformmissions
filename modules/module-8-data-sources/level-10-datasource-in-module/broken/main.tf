# The child module exposes output "file_content",
# but the root module references "content" (wrong name).
# Fix: change module.reader.content to module.reader.file_content

module "reader" {
  source   = "./modules/reader"
  filepath = "${path.module}/info.txt"
}

output "result" {
  value = module.reader.content
}
