# Kestrel Peak lift tickets.
# Both resources were renamed in a cleanup commit (lift_pass -> day_pass,
# gate_sign -> turnstile_sign). The tickets already printed carry the old code.

resource "random_id" "day_pass" {
  byte_length = 4
  prefix      = "KP-"
}

resource "local_file" "turnstile_sign" {
  filename = "${path.module}/signs/turnstile.txt"
  content  = "Scan code ${random_id.day_pass.hex} at the gate\n"
}

moved {
  from = random_id.lift_pass
  to   = random_id.day_pass
}

moved {
  from = local_file.gate_sign
  to   = local_file.turnstile_sign
}
