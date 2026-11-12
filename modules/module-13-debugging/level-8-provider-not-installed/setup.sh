#!/usr/bin/env bash
source "$TM_LIB"
# 1. The checkout as it was: applied once.
tm_apply
tm_record boat "$(tm_output_raw boat_name)"
# 2. A colleague's branch lands: new provider requirement and new resources, but nobody re-ran init.
cat >terraform.tf <<'EOF'
terraform {
  required_version = ">= 1.10"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}
EOF
cat >signing.tf <<'EOF'
# Dive logs are now signed by the instructor's key.

resource "tls_private_key" "logbook_signer" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "local_file" "signature_card" {
  filename = "${path.module}/divelog/signature.txt"
  content  = "Logbook signer: ${tls_private_key.logbook_signer.public_key_fingerprint_sha256}\n"
}

output "signing_fingerprint" {
  value = tls_private_key.logbook_signer.public_key_fingerprint_sha256
}
EOF
exit 0
