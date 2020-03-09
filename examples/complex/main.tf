terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = ">= 2.27"
  region  = local.region
}

locals {
  region = "eu-west-1"
  aws_account = "123456789"
}

module "aws-config" {
  source = "../../"


  aws_region        = local.region
  global_name       = "security-baseline-module"
  global_project    = "security-module-complex"
  local_environment = "dev"

  tags = {
  Project     = "security-complex-dev"
  Environment = "dev"
  }

  # Set up CloudWatch alarms to notify you when critical changes happen in your AWS account.
  cloudwatch_enabled = true
  alarm_namespace = "CISBenchmark"
  cloudtrail_log_group_name = "dev-cloudtrai-logs"
  sns_topic_name = "CISAlarm"


  # Enable CloudTrail in all regions and deliver events to CloudWatch Logs.
  cloudtrail_enabled = true
  aws_account_id = local.aws_account
  cloudtrail_name = "cloudtrail-multi-region"
  cloudtrail_sns_topic_name = "cloudtrail-multi-region-sns-topic"
  cloudwatch_logs_retention_in_days = 365
  cloud_trail_iam_role_name = "CloudTrail-CloudWatch-Delivery-Role"
  cloud_trail_iam_role_policy_name = "CloudTrail-CloudWatch-Delivery-Policy"
  key_deletion_window_in_days = 10
  s3_bucket_name = "cloud-trail-dev"
  s3_key_prefix = "secure-baseline"
  is_organization_trail = false


  #Enable AWS Config in all regions to automatically take configuration snapshots.
  aws_config_enabled = true
  aws_config_iam_role_arn = "arn:aws:iam::${local.aws_account}:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig"
  aws_config_sns_topic_name = "ConfigChanges"
  delivery_frequency = "Three_Hours"
  recorder_name = "default"
  delivery_channel_name = "default"
  include_global_resource_types = true

  #Enable GuardDuty in all regions.
  guard_duty_enabled = true
  disable_email_notification = false
  finding_publishing_frequency = "SIX_HOURS"
  invitation_message = "Welcome to Guard duty"
  master_account_id = ""
  member_accounts = []

  # Set up IAM Password Policy and create default IAM roles for managing AWS account.
  master_iam_role_enabled = "true"
  master_iam_role_name = "IAM-Master"
  master_iam_role_policy_name = "IAM-Master-Policy"
  master_iam_role_policy_json = ""
  master_iam_role_permissions_boundary_arn = ""
  manager_iam_role_enabled = "true"
  manager_iam_role_name = "IAM-Manager"
  manager_iam_role_policy_name = "IAM-Manager-Policy"
  manager_iam_role_policy_json = ""
  manager_iam_role_permissions_boundary_arn = ""
  support_iam_role_name = "IAM-Support"
  support_iam_role_policy_name = "IAM-Support-Role"
  support_iam_role_principal_arns = ["arn:aws:iam::${local.aws_account}:role/aws-service-role/support.amazonaws.com/AWSServiceRoleForSupport"]
  support_iam_role_permissions_boundary_arn = ""
  max_password_age = 90
  minimum_password_length = 14
  password_reuse_prevention = 24
  require_lowercase_characters = true
  require_numbers = true
  require_symbols = true
  allow_users_to_change_password = true


  #Creates a S3 bucket with access logging enabled.
  secure_bucket_enabled = true
  secure_log_bucket_name = "secure-baseline-log-bucket"
  lifecycle_glacier_transition_days = 90
  force_destroy = true

  #Enable SecurityHub and subscribe CIS benchmark standard.


  #Enable VPC Flow Logs with the default VPC in all regions.
  vpc_logs_enabled = true
  vpc_log_group_name = "vpc-logs-multi-region"
  vpc_flow_logs_iam_role_arn = "arn:aws:iam::${local.aws_account}:role/vpcFlowLogsRole"
  vpc_log_retention_in_days = 365


  #AWS Config custom rules
  eip_attached_rule_enabled = true
  iam_user_no_policies_check_rule_enabled = true
  ec2_instance_managed_by_systems_manager_rule_enabled = true
  default_security_group_closed_check_rule_enabled = true
  sg_atatched_to_eni_rule_enabled = true
  rds_multi_az_support = true
}


