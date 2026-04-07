resource "local_file" "nginx_conf" {
  content  = <<-EOF
    server {
      listen 80;
      server_name example.com;
    }
  EOF
  filename = "${path.module}/nginx.conf"
}
