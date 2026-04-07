data "http" "api" {
  url = "https://httpbin.org/get"
}

output "response_status" {
  value = data.http.api.status_code
}
