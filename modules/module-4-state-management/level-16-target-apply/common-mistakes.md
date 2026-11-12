# Common mistakes

- **Running a full `terraform apply`.** It fails on the customs precondition, and nothing is created.
- **Deleting or loosening the precondition.** That publishes a cargo manifest nobody cleared, which is what the check exists to prevent.
- **Creating pending/customs-stamp.txt yourself.** That fakes the clearance; the validator checks the stamp is still missing.
- **Targeting `random_id.route_code` only.** The code exists but the chart is not published.
- **Listing every resource with `-target` except the cargo.** It also creates the pilot, which is not wanted tonight; target only what you need.
