# Wall placards for the Marlowe Museum's spring exhibition.
variable "curator" {
  type    = string
  default = "Ines Calloway"
}

resource "local_file" "gallery_four" {
  filename = "${path.module}/placards/gallery-4.txt"
  content  = "Gallery 4: Impressionists, 1870-1890\nCurated by ${var.curator}\n
}

resource "local_file" "gallery_seven" {
  filename = "${path.module}/placards/gallery-7.txt"
  content  = "Gallery 7: Ceramics\nAsk a guide about the Ming vase.\n"
}

output "placards" {
  value = [local_file.gallery_four.filename, local_file.gallery_seven.filename]
}
