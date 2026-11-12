# Private CA for the Cinder Loop monorail depot: the signal controller must present a
# certificate that chains up to the depot's own root.
resource "tls_private_key" "root" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "root" {
  private_key_pem = tls_private_key.root.private_key_pem

  subject {
    common_name  = "Cinder Loop Depot Root CA"
    organization = "Cinder Loop Monorail"
  }

  validity_period_hours = 8760
  is_ca_certificate     = true
  allowed_uses          = ["cert_signing", "crl_signing", "digital_signature"]
}

resource "tls_private_key" "signals" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "signals" {
  private_key_pem = tls_private_key.signals.private_key_pem
  dns_names       = ["signals.cinderloop.test"]

  subject {
    common_name  = "signals.cinderloop.test"
    organization = "Cinder Loop Monorail"
  }
}

resource "tls_locally_signed_cert" "signals" {
  cert_request_pem   = tls_cert_request.signals.cert_request_pem
  ca_private_key_pem = tls_private_key.root.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.root.cert_pem

  validity_period_hours = 2160
  allowed_uses          = ["digital_signature", "server_auth"]
}

resource "local_file" "root_pem" {
  filename = "${path.module}/pki/root-ca.pem"
  content  = tls_self_signed_cert.root.cert_pem
}

resource "local_file" "signals_pem" {
  filename = "${path.module}/pki/signals.pem"
  content  = tls_locally_signed_cert.signals.cert_pem
}
