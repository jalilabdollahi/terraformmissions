module "file_writer" {
  source   = "./modules/file_writer"
  content  = "Hello from the upgraded module"
  basename = "output"
}

output "written_file" {
  value = module.file_writer.filename
}
