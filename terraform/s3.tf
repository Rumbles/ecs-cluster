resource "aws_s3_bucket" "ecs_private_bucket" {
  bucket        = var.cluster_name
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = false
  }
  lifecycle {
    prevent_destroy = false
    ignore_changes  = [tags, bucket]
  }
}

resource "aws_s3_bucket_public_access_block" "ecs_private_bucket" {
  bucket = aws_s3_bucket.ecs_private_bucket.id

  block_public_acls         = true
  block_public_policy       = true
  ignore_public_acls        = true
  restrict_public_buckets   = true
}
