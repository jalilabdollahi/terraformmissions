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
    common_name  = "Indigo Row Sorting Line CA"
    organization = "Indigo Row Recycling Plant"
  }
}

resource "tls_private_key" "sorter" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "sorter" {
  key_algorithm   = tls_private_key.sorter.algorithm
  private_key_pem = tls_private_key.sorter.private_key_pem
  dns_names       = ["belt-sorter-07.indigorow.test"]

  subject {
    common_name  = "belt-sorter-07.indigorow.test"
    organization = "Indigo Row Recycling Plant"
  }
}

resource "tls_locally_signed_cert" "sorter" {
  cert_request_pem      = tls_cert_request.sorter.cert_request_pem
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

resource "local_file" "sorter_pem" {
  filename = "${path.module}/pki/sorter.pem"
  content  = tls_locally_signed_cert.sorter.cert_pem
}

resource "local_sensitive_file" "sorter_key" {
  filename        = "${path.module}/pki/sorter.key"
  content         = tls_private_key.sorter.private_key_pem
  file_permission = "0600"
}

output "sorter_fingerprint_source" {
  value = tls_private_key.sorter.public_key_fingerprint_sha256
}
