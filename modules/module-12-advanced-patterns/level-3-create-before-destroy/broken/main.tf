# Bug: both resources write to the same filename with create_before_destroy = true.
# On replacement, the new resource tries to create the file before the old one is destroyed,
# causing a collision.

resource "local_file" "config_a" {
  content  = "config A"
  filename = "${path.module}/shared.txt"

  lifecycle {
    create_before_destroy = true
  }
}

resource "local_file" "config_b" {
  content  = "config B"
  filename = "${path.module}/shared.txt"

  lifecycle {
    create_before_destroy = true
  }
}
