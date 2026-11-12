output "lane_files" {
  value = local_file.lane[*].filename
}
