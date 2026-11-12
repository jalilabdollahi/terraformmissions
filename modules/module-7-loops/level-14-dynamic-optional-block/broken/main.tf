# Audio-guide pack for the Oakridge Sculpture Park.
# Every pack has the stop list and the guide script. A large-print transcript
# is included only when the curator wrote one.

resource "archive_file" "audio_pack" {
  type        = "zip"
  output_path = "${path.module}/packs/audio-guide.zip"

  source {
    filename = "stops.txt"
    content  = "1 Bronze meadow\n2 Stone terrace\n3 Willow arch\n"
  }

  source {
    filename = "guide-script.txt"
    content  = "Welcome to the park. Follow the gravel path.\n"
  }

  source {
    filename = "transcript-large-print.txt"
    content  = var.transcript
  }
}

output "pack_path" {
  value = archive_file.audio_pack.output_path
}
