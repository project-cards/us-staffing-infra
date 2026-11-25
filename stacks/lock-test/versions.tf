# ----------------------------------------------------------------------------
# versions.tf (stack: lock-test)
#
# A throwaway stack used ONLY to practise DynamoDB locking.
# It creates nothing in AWS. Its state lives in the S3 bucket, and its lock
# uses the DynamoDB table (the legacy method).
#
# dynamodb_table is the legacy setting. Terraform 1.11+ shows a deprecation
# warning for it. That warning is expected here, and it's part of the lesson.
# ----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.10.0"

  backend "s3" {
    bucket         = "us-staffing-tfstate-061624868468-ap-south-1"
    key            = "lock-test/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "us-staffing-tfstate-lock" # legacy locking: the table we created
  }
}
