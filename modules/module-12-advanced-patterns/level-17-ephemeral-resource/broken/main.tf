# ZipWheel e-scooter rental: scooter 07 needs a certificate signing request.
# The scooter's private key must exist only for the duration of the run: it is generated
# as an ephemeral resource, used to sign the request and never written to the state file.
# The request itself (public data) is saved to pki/scooter-07.csr.

ephemeral "tls_private_key" "scooter" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "scooter" {
  private_key_pem = ephemeral.tls_private_key.scooter.private_key_pem

  subject {
    common_name  = "scooter-07.zipwheel.example"
    organization = "ZipWheel E-Scooter Rental"
  }
}

resource "local_file" "csr" {
  filename = "${path.module}/pki/scooter-07.csr"
  content  = tls_cert_request.scooter.cert_request_pem
}
