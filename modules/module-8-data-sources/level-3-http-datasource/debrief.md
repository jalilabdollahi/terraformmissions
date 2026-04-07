# Invalid URL Scheme

## What Was Broken
The `url` attribute was set to `"not-a-url"`, which has no scheme. The `hashicorp/http` provider
requires a fully-qualified URL beginning with `http://` or `https://`.

## The Fix
```hcl
data "http" "api" {
  url = "https://httpbin.org/get"
}
```

## Key Concepts
- The `hashicorp/http` provider (~> 3.4) exposes `data "http"` for making HTTP GET requests.
- The URL must be absolute and include a scheme.
- Validation happens at `terraform validate` time — no network call is needed to catch this error.

## Useful Attributes
| Attribute          | Description |
|-------------------|-------------|
| `response_body`    | The HTTP response body as a string |
| `status_code`      | The HTTP response status code (integer) |
| `response_headers` | Map of response headers |