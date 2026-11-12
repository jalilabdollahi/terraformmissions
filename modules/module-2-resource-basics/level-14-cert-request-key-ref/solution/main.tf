# Certificate signing request for a Fernhollow greenhouse humidity sensor.
# The sensor's firmware generates nothing itself: Terraform makes the key and
# the CSR, and the CA team signs the CSR.

resource "tls_private_key" "sensor" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "sensor" {
  private_key_pem = tls_private_key.sensor.private_key_pem

  subject {
    common_name         = "humidity-07.fernhollow.example"
    organization        = "Fernhollow Greenhouses"
    organizational_unit = "Sensors"
  }

  dns_names = ["humidity-07.fernhollow.example"]
}

resource "local_file" "csr" {
  filename = "${path.module}/pki/humidity-07.csr"
  content  = tls_cert_request.sensor.cert_request_pem
}

resource "local_sensitive_file" "sensor_key" {
  filename        = "${path.module}/pki/humidity-07.key"
  content         = tls_private_key.sensor.private_key_pem
  file_permission = "0600"
}
