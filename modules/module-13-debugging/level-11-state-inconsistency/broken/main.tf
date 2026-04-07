resource "local_file" "config" {
  content  = "fresh config"
  filename = "${path.module}/config.txt"
}
