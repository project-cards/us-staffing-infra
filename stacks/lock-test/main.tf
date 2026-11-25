# ----------------------------------------------------------------------------
# main.tf (stack: lock-test)
#
# terraform_data is a built-in resource that creates nothing in AWS. It only
# records a value in state, so the stack has something to plan and apply.
# ----------------------------------------------------------------------------

resource "terraform_data" "lock_test" {
  input = "DynamoDB locking practice"
}
