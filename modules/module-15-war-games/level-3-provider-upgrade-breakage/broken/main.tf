# Indigo Row Dye Works - mutual TLS for the vat-floor colour scanners.
# Written against hashicorp/tls 3.x. The platform team bumped the constraint in terraform.tf
# to ~> 4.0 and CI has been red since. The scanners PIN the CA key and the scanner key,
# so those two keys must survive whatever we do here.

resource "tls_private_key" "ca" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "ca" {
  key_algorithm         = tls_private_key.ca.algorithm
  private_key_pem       = tls_private_key.ca.private_key_pem
  is_ca_certificate     = true
  validity_period_hours = 8760
  allowed_uses          = ["cert_signing", "crl_signing"]

  subject {
    common_name  = "Indigo Row Vat Floor CA"
    organization = "Indigo Row Dye Works"
  }
}

resource "tls_private_key" "scanner" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "scanner" {
  key_algorithm   = tls_private_key.scanner.algorithm
  private_key_pem = tls_private_key.scanner.private_key_pem
  dns_names       = ["vat-scanner-07.indigorow.test"]

  subject {
    common_name  = "vat-scanner-07.indigorow.test"
    organization = "Indigo Row Dye Works"
  }
}

resource "tls_locally_signed_cert" "scanner" {
  cert_request_pem      = tls_cert_request.scanner.cert_request_pem
  ca_key_algorithm      = tls_private_key.ca.algorithm
  ca_private_key_pem    = tls_private_key.ca.private_key_pem
  ca_cert_pem           = tls_self_signed_cert.ca.cert_pem
  validity_period_hours = 4380
  allowed_uses          = ["digital_signature", "client_auth"]
}

resource "local_file" "ca_pem" {
  filename = "${path.module}/pki/ca.pem"
  content  = tls_self_signed_cert.ca.cert_pem
}

resource "local_file" "scanner_pem" {
  filename = "${path.module}/pki/scanner.pem"
  content  = tls_locally_signed_cert.scanner.cert_pem
}

resource "local_sensitive_file" "scanner_key" {
  filename        = "${path.module}/pki/scanner.key"
  content         = tls_private_key.scanner.private_key_pem
  file_permission = "0600"
}

output "scanner_fingerprint_source" {
  value = tls_private_key.scanner.public_key_fingerprint_sha256
}
