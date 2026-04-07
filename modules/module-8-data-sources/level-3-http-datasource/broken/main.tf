# The URL is missing the https:// scheme.
# Fix: change "not-a-url" to a valid URL like "https://httpbin.org/get"

data "http" "api" {
  url = "not-a-url"
}

output "response_status" {
  value = data.http.api.status_code
}
