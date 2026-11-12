# Frostbite ice cream trucks: payment terminal 07 needs a certificate signing request.
# The terminal's private key must exist only for the duration of the run: it is generated
# as an ephemeral resource, used to sign the request and never written to the state file.
# The request itself (public data) is saved to pki/terminal-07.csr.

ephemeral "tls_private_key" "terminal" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "terminal" {
  private_key_pem_wo         = ephemeral.tls_private_key.terminal.private_key_pem
  private_key_pem_wo_version = 1

  subject {
    common_name  = "terminal-07.frostbite.example"
    organization = "Frostbite Ice Cream Trucks"
  }
}

resource "local_file" "csr" {
  filename = "${path.module}/pki/terminal-07.csr"
  content  = tls_cert_request.terminal.cert_request_pem
}
