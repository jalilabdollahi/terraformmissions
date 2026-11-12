# Common mistakes

- **Running a full `terraform apply`.** It fails on the weighbridge precondition, and nothing is created.
- **Deleting or loosening the precondition.** That publishes a load manifest nobody cleared, which is what the check exists to prevent.
- **Creating pending/weighbridge-ticket.txt yourself.** That fakes the clearance; the validator checks the ticket is still missing.
- **Targeting `random_id.route_code` only.** The code exists but the chart is not published.
- **Listing every resource with `-target` except the load.** It also creates the driver, which is not wanted tonight; target only what you need.
