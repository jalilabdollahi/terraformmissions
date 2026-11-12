# URL slugs for the "Static & Signal" podcast episodes.
# Editors may override the separator (for example "_" for the legacy site);
# if they do not, random_pet should use its own default.
variable "slug_separator" {
  description = "Optional separator between slug words; unset means the provider default"
  type        = string
  default     = ""
}

resource "random_pet" "episode" {
  prefix    = "ep"
  length    = 2
  separator = var.slug_separator
}

resource "local_file" "slug_sheet" {
  filename = "${path.module}/podcast/slug.txt"
  content  = "Next episode slug: ${random_pet.episode.id}\n"
}

output "slug" {
  value = random_pet.episode.id
}
