module "secure-baseline_cloudtrail-baseline" {
  source  = "nozaq/secure-baseline/aws//modules/cloudtrail-baseline"
  version = "0.20.0"


  enabled                           = var.cloudtrail_enabled
  aws_account_id                    = var.aws_account_id
  region                            = var.aws_region
  cloudtrail_name                   = var.cloudtrail_name
  cloudtrail_sns_topic_name         = var.cloudtrail_sns_topic_name
  cloudwatch_logs_group_name        = var.cloudtrail_log_group_name
  cloudwatch_logs_retention_in_days = var.cloudwatch_logs_retention_in_days
  iam_role_name                     = var.cloud_trail_iam_role_name
  iam_role_policy_name              = var.cloud_trail_iam_role_policy_name
  key_deletion_window_in_days       = var.key_deletion_window_in_days
  s3_bucket_name                    = var.s3_bucket_name
  s3_key_prefix                     = var.s3_key_prefix
  is_organization_trail             = var.is_organization_trail
  tags                              = local.tags
}