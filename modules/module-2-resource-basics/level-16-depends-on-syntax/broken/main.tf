# Chapter index for a hand-bound cookbook from the Linden Lane bindery.
# The page counter reads chapters.txt, so it must only run once that file is
# in place. Terraform can't see that dependency by itself (the counter is a
# shell command that reads the file by path), so the author declared it.

resource "local_file" "chapters" {
  filename = "${path.module}/book/chapters.txt"
  content  = "Soups\nBreads\nPickles\nPuddings\nPreserves\n"
}

resource "terraform_data" "page_counter" {
  depends_on = ["local_file.chapters"]

  provisioner "local-exec" {
    command = "wc -l < book/chapters.txt | tr -d ' ' > book/chapter-count.txt"
  }
}

resource "local_file" "cover" {
  filename   = "${path.module}/book/cover.txt"
  content    = "THE LINDEN LANE COOKBOOK\n"
  depends_on = [local_file.chapters.filename]
}

output "counter_id" {
  value = terraform_data.page_counter.id
}
