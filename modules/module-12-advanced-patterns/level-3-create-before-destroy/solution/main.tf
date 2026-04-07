resource "local_file" "config_a" {
  content  = "config A"
  filename = "${path.module}/config-a.txt"

  lifecycle {
    create_before_destroy = true
  }
}

resource "local_file" "config_b" {
  content  = "config B"
  filename = "${path.module}/config-b.txt"

  lifecycle {
    create_before_destroy = true
  }
}
