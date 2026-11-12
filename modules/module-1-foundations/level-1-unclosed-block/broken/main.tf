# Morning bake plan for the Crumb & Kettle bakery.
locals {
  batches = [
    { time = "05:30", loaf = "sourdough" },
    { time = "06:15", loaf = "rye" },
    { time = "07:00", loaf = "focaccia" },
  ]
}

resource "local_file" "dough_card" {
  filename = "${path.module}/bakery/dough-card.txt"
  content  = "Sourdough: 750g flour, 540g water, 15g salt\n"
}

output "schedule_file" {
  value = local_file.oven_schedule.filename
}

# Pinned to the oven door for the early shift.
resource "local_file" "oven_schedule" {
  filename = "${path.module}/bakery/oven-schedule.txt"
  content  = "${join("\n", [for b in local.batches : "${b.time} ${b.loaf}"])}\n"
