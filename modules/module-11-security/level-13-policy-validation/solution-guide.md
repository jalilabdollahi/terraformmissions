# Walkthrough — Saint Odran Gateway Policy

1. Probe the current rules:
   ```bash
   terraform plan -var 'allowed_cidrs=["::/0"]'          # accepted: wrong
   terraform plan -var 'allowed_cidrs=["0.0.0.0/1"]'     # accepted: wrong
   terraform plan -var min_tls_version=1.0               # accepted: wrong
   ```
2. The CIDR condition `!contains(var.allowed_cidrs, "0.0.0.0/0")` blocks one spelling of "the whole internet"; `::/0`, `0.0.0.0/1` and an empty list pass.
   Express the policy itself — a prefix length floor:
   ```hcl
   condition = length(var.allowed_cidrs) > 0 && alltrue([
     for c in var.allowed_cidrs :
     can(cidrhost(c, 0)) ? tonumber(split("/", c)[1]) >= 8 : false
   ])
   ```
   The `can()` conditional makes malformed input fail validation instead of crashing with an index error.
3. The TLS list contains `1.0` and `1.1`. Restrict it to `["1.2", "1.3"]`.
4. Re-run the probes: each should fail with *Invalid value for variable*. The defaults must still plan. Type `check`.
