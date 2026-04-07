# Chain: A (base) -> B (processed) -> C (enriched) -> D (final)

resource "local_file" "base" {
  content  = "base content"
  filename = "${path.module}/base.txt"
}

resource "local_file" "processed" {
  content  = "processed: ${local_file.base.content}"
  filename = "${path.module}/processed.txt"
}

resource "local_file" "enriched" {
  content  = "enriched: ${local_file.processed.content}"
  filename = "${path.module}/enriched.txt"
}

resource "local_file" "final" {
  content  = "final: ${local_file.enriched.content} (base was: ${local_file.base.filename})"
  filename = "${path.module}/final.txt"
}
