# Audio-guide day passes for the Cobalt Yard Castle Ruins Visitor Centre.
# Policy from the app vendor: 12 characters, with some of every class so
# the guide app accepts it.

resource "random_password" "audio_guide" {
  length      = 12
  min_upper   = 3
  min_lower   = 3
  min_numeric = 3
  min_special = 2
}

resource "local_sensitive_file" "voucher" {
  filename = "${path.module}/ticket-desk/daypass-voucher.txt"
  content  = "Cobalt Yard castle ruins audio guide\nPassword: ${random_password.audio_guide.result}\n"
}

output "audio_guide_password" {
  value     = random_password.audio_guide.result
  sensitive = true
}
