# BUG: splat expression used on a single resource without count or for_each.
# local_file.config is a single instance, not a list — [*] requires count/for_each.

resource "local_file" "config" {
  content  = "config content"
  filename = "${path.module}/config.txt"
}

output "all_filenames" {
  value = local_file.config[*].filename
}
