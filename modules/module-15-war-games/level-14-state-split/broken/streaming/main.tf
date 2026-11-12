# Halcyon - streaming stack (new home of the CDN key, encoders and playlist).

data "terraform_remote_state" "venue" {
  backend = "local"
  config = {
    path = "${path.module}/../venue/terraform.tfstate"
  }
}

data "terraform_remote_state" "ticketing" {
  backend = "local"
  config = {
    path = "${path.module}/../ticketing/terraform.tfstate"
  }
}

resource "random_id" "stream_key" {
  byte_length = 6
}

resource "terraform_data" "encoder" {
  for_each = toset(["a", "b"])
  input    = "encoder-${each.key}"
}

resource "local_file" "playlist" {
  filename = "${path.module}/../out/playlist.txt"
  content  = "stream ${random_id.stream_key.hex} hall ${data.terraform_remote_state.venue.outputs.hall_key} gold ${data.terraform_remote_state.ticketing.outputs.gold_series}\n"
}
