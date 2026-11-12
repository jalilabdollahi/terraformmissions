# Audio-guide pack for the Tidewater Maritime Museum.
# Every pack has the stop list and the guide script. A large-print transcript
# is included only when the curator wrote one.

resource "archive_file" "audio_pack" {
  type        = "zip"
  output_path = "${path.module}/packs/audio-guide.zip"

  source {
    filename = "stops.txt"
    content  = "1 Figurehead hall\n2 Lamp room\n3 Anchor yard\n"
  }

  source {
    filename = "guide-script.txt"
    content  = "Welcome aboard. Follow the blue line.\n"
  }

  source {
    filename = "transcript-large-print.txt"
    content  = var.transcript
  }
}

output "pack_path" {
  value = archive_file.audio_pack.output_path
}
