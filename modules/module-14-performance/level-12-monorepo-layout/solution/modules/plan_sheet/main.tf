resource "local_file" "sheet" {
  filename = "${var.out_dir}/${var.unit}.txt"
  content  = "${join("\n", var.lines)}\n"
}

output "sheet_path" {
  value = local_file.sheet.filename
}
