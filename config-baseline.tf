module "secure-baseline_config-baseline" {
  source  = "nozaq/secure-baseline/aws//modules/config-baseline"
  version = "0.17.0"

  enabled                       = var.aws_config_enabled
  iam_role_arn                  = var.aws_config_iam_role_arn
  sns_topic_name                = var.aws_config_sns_topic_name
  delivery_frequency            = var.delivery_frequency
  recorder_name                 = var.recorder_name
  delivery_channel_name         = var.delivery_channel_name
  include_global_resource_types = var.include_global_resource_types
  tags                          = local.tags
  s3_bucket_name                = var.s3_bucket_name
  s3_key_prefix                 = var.s3_key_prefix

}
