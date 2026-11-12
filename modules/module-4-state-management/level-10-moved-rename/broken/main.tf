# Splashdown Cove day wristbands.
# Both resources were renamed in a cleanup commit (wave_pass -> day_pass,
# entrance_sign -> turnstile_sign). The wristbands already printed carry the old code.

resource "random_id" "day_pass" {
  byte_length = 4
  prefix      = "SC-"
}

resource "local_file" "turnstile_sign" {
  filename = "${path.module}/signs/turnstile.txt"
  content  = "Scan code ${random_id.day_pass.hex} at the gate\n"
}
