# Tidewater Brewery - bottling line paperwork and dispatch.

resource "random_pet" "batch" {
  length    = 2
  separator = "-"
  prefix    = "run"
}

resource "local_file" "recipe" {
  filename = "${path.module}/bottling/recipe.txt"
  content  = "Recipe sheet for ${random_pet.batch.id}\n"
}

# The label printer needs a moment to warm up before it can print proofs.
resource "time_sleep" "printer_warmup" {
  create_duration = "2s"
  triggers = {
    batch = random_pet.batch.id
  }
}

resource "local_file" "labels" {
  filename = "${path.module}/bottling/labels.txt"
  content  = "Label proofs for ${random_pet.batch.id} (printer warm-up ${time_sleep.printer_warmup.create_duration})\n"
}

resource "local_file" "cap_order" {
  filename = "${path.module}/bottling/caps.txt"
  content  = "Cap order for ${random_pet.batch.id}: 4800 crown caps\n"
}

# The manifest lists the sheets that belong to the run.
resource "local_file" "manifest" {
  filename = "${path.module}/bottling/manifest.txt"
  content  = "Manifest: recipe ${local_file.recipe.content_sha256}, labels ${local_file.labels.content_sha256}\n"
}

# Dispatch pulls the run's paperwork out of the bottling folder and logs the hand-over.
resource "terraform_data" "dispatch" {
  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/ship.sh"
    environment = {
      CAP_ORDER = local_file.cap_order.filename
    }
  }
}

output "batch_id" {
  value = random_pet.batch.id
}
