# Common mistakes

- **Adding more `local_file` blocks, one per clue.** It works today, but it throws away the `count` the
  mission wants to keep and breaks as soon as the clue list grows.
- **Using a random suffix in the filename.** Names become unique but unpredictable, so the host
  cannot find `clue-0.txt`, and the names change on every apply.
- **Writing `clue-${var.clues[count.index]}.txt`.** That uses the clue text, spaces included, as a file
  name instead of its position.
- **Using `count.index` only in `content`.** The filename is still shared, so there is still one file.
