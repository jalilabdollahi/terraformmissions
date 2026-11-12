# Walkthrough - Blind Tasting Count

1. `terraform plan` stops with `Invalid count argument` and points at `count = length(random_shuffle.panel.result)`.
2. Reason about what is known when: `random_shuffle.panel.result` is "(known after apply)". Terraform has to decide how
   many `tasting_card` instances exist *before* it applies anything, so it cannot use a computed value there.
3. The length of the result is a value you already know: you set it with `result_count = var.panel_size`.
4. Change the line to `count = var.panel_size`. The `[count.index]` lookup into the shuffle result is fine - the
   *content* of each card may stay unknown until apply.
5. `terraform apply`, then `terraform plan -var panel_size=4` to confirm it plans one extra card, then `check`.
