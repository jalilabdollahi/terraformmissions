output "bib_range" {
  value = "${var.first_bib}-${local.last_bib}"
}

output "city" {
  value = var.race_city
}
