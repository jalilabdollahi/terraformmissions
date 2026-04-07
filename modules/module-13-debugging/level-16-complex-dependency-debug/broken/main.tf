# Chain: A (base) -> B (processed) -> C (enriched) -> D (final)
# Bug: local_file.base (A) is not declared — only B, C, D exist.

resource "local_file" "processed" {
  # B depends on A
  content  = "processed: ${local_file.base.content}"
  filename = "${path.module}/processed.txt"
}

resource "local_file" "enriched" {
  # C depends on B
  content  = "enriched: ${local_file.processed.content}"
  filename = "${path.module}/enriched.txt"
}

resource "local_file" "final" {
  # D depends on C and references A
  content  = "final: ${local_file.enriched.content} (base was: ${local_file.base.filename})"
  filename = "${path.module}/final.txt"
}
