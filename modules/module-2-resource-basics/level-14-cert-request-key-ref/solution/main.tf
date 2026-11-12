# Certificate signing request for a Saltmarsh offshore wind farm turbine sensor.
# The sensor's firmware generates nothing itself: Terraform makes the key and
# the CSR, and the CA team signs the CSR.

resource "tls_private_key" "sensor" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "sensor" {
  private_key_pem = tls_private_key.sensor.private_key_pem

  subject {
    common_name         = "turbine-07.saltmarsh.example"
    organization        = "Saltmarsh Offshore Wind"
    organizational_unit = "Sensors"
  }

  dns_names = ["turbine-07.saltmarsh.example"]
}

resource "local_file" "csr" {
  filename = "${path.module}/pki/turbine-07.csr"
  content  = tls_cert_request.sensor.cert_request_pem
}

resource "local_sensitive_file" "sensor_key" {
  filename        = "${path.module}/pki/turbine-07.key"
  content         = tls_private_key.sensor.private_key_pem
  file_permission = "0600"
}
