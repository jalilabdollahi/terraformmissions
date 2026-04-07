module "file_writer" {
  source   = "./modules/file_writer"
  content  = "Hello from the upgraded module"
  basename = "output"
}

# BUG: The module output was renamed from "file_path" to "filename" in the upgrade.
# This reference uses the old name and will fail.
output "written_file" {
  value = module.file_writer.file_path
}
