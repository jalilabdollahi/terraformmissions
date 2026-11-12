# The map room stamps a proof copy of the compass-rose engraving before it goes to the press.

data "local_file" "rose" {
  filename = "${path.module}/art/compass-rose.png"
}

resource "local_file" "proof" {
  filename = "${path.module}/press/rose-proof.png"
  content  = data.local_file.rose.content
}

output "engraving_sha256" {
  value = data.local_file.rose.content_sha256
}

output "proof_path" {
  value = local_file.proof.filename
}
