#!/usr/bin/env bash
source "$TM_LIB"
# Apply the OLD count-based configuration first so state holds random_pet.mascot[0..2].
cp main.tf "$TM_TMP/main.tf.new"
cat > main.tf <<'EOF'
resource "random_pet" "mascot" {
  count     = length(var.pedalos)
  length    = 2
  separator = "-"
}

resource "local_file" "roster" {
  filename = "${path.module}/roster.txt"
  content = join("\n", [
    for i, s in var.pedalos : "${s}: ${random_pet.mascot[i].id}"
  ])
}
EOF
tm_apply
i=0
for s in odette odile benno; do
  tm_record "pet_$s" "$(tm_state_attr "random_pet.mascot[$i]" id)"
  i=$((i + 1))
done
cp "$TM_TMP/main.tf.new" main.tf
