# ----------------------------------------------------------------------------
# main.tf (module: ecr)
#
# One image repository per app (the shelves), with three protections:
#   - IMMUTABLE tags: a tag can't be overwritten, so the tested image is the deployed one.
#   - Scan on push: every new image is checked for known security problems.
#   - KMS encryption: the images are encrypted with our key.
# A lifecycle rule keeps the last 20 images, so storage doesn't grow forever.
# ----------------------------------------------------------------------------

resource "aws_ecr_repository" "app" {
  for_each = toset(var.repo_names)

  name                 = each.value
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = var.kms_key_arn
  }

  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "app" {
  for_each   = aws_ecr_repository.app
  repository = each.value.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep the last 20 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 20
      }
      action = { type = "expire" }
    }]
  })
}
