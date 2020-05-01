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
  global_project    = "security-module-basic"
  local_environment = "dev"

  tags = {
  Project     = "security-basic-dev"
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
  guard_duty_enabled = false


  # Set up IAM Password Policy and create default IAM roles for managing AWS account.
  master_iam_role_enabled = false


  #Creates a S3 bucket with access logging enabled.
  secure_bucket_enabled = true
  secure_log_bucket_name = "secure-baseline-log-bucket"
  lifecycle_glacier_transition_days = 30
  force_destroy = true


  #Enable VPC Flow Logs with the default VPC in all regions.
  vpc_logs_enabled = false


  #AWS Config custom rules
  eip_attached_rule_enabled                                = true
  iam_password_policy_rule_enabled                         = false
  iam_user_no_policies_check_rule_enabled                  = false
  root_account_mfa_enabled_rule_enabled                    = false
  s3_bucket_ssl_requests_only_rule_enabled                 = false
  ebs_encrypted_volumes_check_rule_enabled                 = false
  sg_ssh_restricted_check_rule_enabled                     = false
  sg_unrestricted_common_ports_check_rule_enabled          = false
  ec2_unused_ebs_volumes_check_rule_enabled                = false
  ebs_snapshots_not_publicly_restorable_check_rule_enabled = false
  ec2_stopped_instances_check_rule_enabled                 = false
  ec2_instance_managed_by_systems_manager_rule_enabled     = false
  default_security_group_closed_check_rule_enabled         = false
  sg_atatched_to_eni_rule_enabled                          = false
  sg_open_to_specific_ports_only_rule_enabled              = false
  s3_public_read_disable_check_rule_enabled                = false
  s3_public_write_disable_check_rule_enabled               = false
  s3_sse_enabled_check_rule_enabled                        = false
  rds_instance_public_access_check_rule_enabled            = false
  db_instance_backup_enabled_rule_enabled                  = false
  rds_snapshots_public_prohibited_rule_enabled             = false
  rds_multi_az_support_rule_enabled                        = false
  rds_storage_encrypted_rule_enabled                       = false


  # IAM credentials report
  iam_credentials_report_enabled = false
  iam_credentials_sns_topic_name = "iam-report-topic"  # Topic will be NOT created. Use of an existing topic is assumed.
  iam_credentials_s3_bucket_name = "iam-report-bucket"
  iam_credentials_s3_file_name   = "iam_credentials_report.csv"

}


