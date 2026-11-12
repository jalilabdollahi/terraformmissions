# Coldharbor Clinic: vaccine freezer labelling.
# The asset tag below was created by an earlier Terraform run. That run's state
# is gone, but the real tag is on the freezer door.

resource "random_id" "freezer_tag" {
  byte_length = 6
}

resource "local_file" "door_label" {
  filename = "${path.module}/labels/freezer-door.txt"
  content  = "FREEZER ASSET TAG ${random_id.freezer_tag.hex}\nKeep at -70C. Do not unplug.\n"
}
