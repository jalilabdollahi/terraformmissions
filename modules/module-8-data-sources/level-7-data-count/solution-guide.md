# Walkthrough — Galley Proof Contents

1. **First error.** `terraform plan` says `Invalid index ... var.galleys ... the given key does not
   identify an element in this collection value`. The filename uses `count.index + 1`, so instance 2
   asks for a fourth chapter. Instances are numbered from 0:
   `filename = "${path.module}/galleys/${var.galleys[count.index]}.txt"`.
2. **Second error.** `Missing resource instance key` for `data.local_file.galley.content`: with
   `count` set, the address refers to a list of instances. Iterate over it:
   ```hcl
   titles = [for g in data.local_file.galley : trimspace(regex("title: (.*)", g.content)[0])]
   ```
   (`data.local_file.galley[0].content` would be a single instance.)
3. `terraform apply` -> `total_words = 3580`. Type `check`.
