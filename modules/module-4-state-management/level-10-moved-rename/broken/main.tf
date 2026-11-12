# Splashdown Treetop Adventure Park climbing passes.
# Both resources were renamed in a cleanup commit (zip_pass -> climb_pass,
# gate_sign -> harness_sign). The harness tags already printed carry the old code.

resource "random_id" "climb_pass" {
  byte_length = 4
  prefix      = "ST-"
}

resource "local_file" "harness_sign" {
  filename = "${path.module}/signs/harness.txt"
  content  = "Scan code ${random_id.climb_pass.hex} at the briefing hut\n"
}
