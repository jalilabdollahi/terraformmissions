# Using path.root instead of path.module — path.root is the root module's directory,
# which is NOT where this child module's files live.
resource "local_file" "config" {
  content  = "generated config"
  filename = "${path.root}/child-config.txt"
}
