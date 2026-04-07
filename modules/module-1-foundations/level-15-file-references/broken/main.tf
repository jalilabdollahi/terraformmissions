resource "local_file" "nginx" {
  content  = templatefile("${path.module}/templates/nginx.conf.tpl", {
    port = 80
    hostname = "example.com"
  })
  filename = "${path.module}/nginx.conf"
}
