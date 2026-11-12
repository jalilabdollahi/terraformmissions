# Alderney Opera wardrobe records.
#
# rack_seal       stamped once on the costume rack; printed on the garment tags
# costume_register  the master list, quotes the seal
# fitting_roster    derived from the register
# dry_clean_notice  tells the laundry about the roster (appends one line per run)
#
# Someone ran `terraform destroy -target=local_file.costume_register` earlier today.
# `terraform state list` will tell you what is left.

resource "random_id" "rack_seal" {
  byte_length = 4
  prefix      = "rack-"
}

resource "local_file" "costume_register" {
  filename = "${path.module}/wardrobe/register.txt"
  content  = "Register sealed ${random_id.rack_seal.hex}\n"
}

resource "local_file" "fitting_roster" {
  filename = "${path.module}/wardrobe/fitting-roster.txt"
  content  = "Fittings follow register ${local_file.costume_register.content_sha1}\n"
}

resource "terraform_data" "dry_clean_notice" {
  input = local_file.fitting_roster.content_sha1

  provisioner "local-exec" {
    command = "echo 'laundry notified' >> ${path.module}/wardrobe/notices.log"
  }
}

output "rack_seal" {
  value = random_id.rack_seal.hex
}
