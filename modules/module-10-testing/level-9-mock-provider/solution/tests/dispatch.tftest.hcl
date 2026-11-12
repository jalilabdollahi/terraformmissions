mock_provider "random" {
  mock_resource "random_id" {
    defaults = {
      hex = "ab12cd34"
    }
  }

  mock_resource "random_integer" {
    defaults = {
      result = 4
    }
  }
}

run "ticket_format" {
  assert {
    condition     = output.ticket == "BK-AB12CD34"
    error_message = "tickets are BK- plus the upper-cased mocked hex id"
  }
}

run "zone_label" {
  assert {
    condition     = output.dispatch_zone == "zone-4"
    error_message = "the mocked integer 4 should produce zone-4"
  }
}

run "both_stamped" {
  assert {
    condition     = startswith(output.ticket, "BK-") && endswith(output.dispatch_zone, "-4")
    error_message = "a job carries both stamps"
  }
}
