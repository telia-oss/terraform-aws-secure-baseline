resource "aws_s3_bucket" "S3SharedBucket" {
  bucket        = var.s3_bucket_name
  acl           = "log-delivery-write"
  force_destroy = var.force_destroy

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = var.s3_bucket_name
    target_prefix = var.s3_key_prefix
  }

  lifecycle_rule {
    id      = "auto-archive"
    enabled = true


    transition {
      days          = var.lifecycle_glacier_transition_days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.s3_bucket_expiration_days
    }

  }
}

resource "aws_s3_bucket_public_access_block" "blockPublicAccess" {
  bucket              = aws_s3_bucket.S3SharedBucket.id
  block_public_acls   = true
  block_public_policy = true
  depends_on          = [aws_s3_bucket_policy.BucketPolicy]
}

data "aws_iam_policy_document" "s3-bucket-policy-forS3SharedBucket" {

  statement {
    actions   = ["s3:GetBucketAcl"]
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.s3_bucket_name}"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com", "config.amazonaws.com"]
    }
  }
  statement {
    actions   = ["s3:PutObject"]
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.s3_bucket_name}/${var.s3_key_prefix}/AWSLogs/${var.aws_account_id}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com", "config.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}
resource "aws_s3_bucket_policy" "BucketPolicy" {
  bucket = aws_s3_bucket.S3SharedBucket.id
  policy = data.aws_iam_policy_document.s3-bucket-policy-forS3SharedBucket.json
}