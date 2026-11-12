# Race-day paperwork for the Ribeira River Run.
# Inputs are meant to come from variables so the same code serves every city.
resource "local_file" "race_sheet" {
  filename = "${path.module}/race/sheet.txt"
  content  = "Ribeira River Run - ${var.race_city}\nRunners registered: ${var.runner_count}\n"
}
