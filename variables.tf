variable "aws_region" {
  description = "AWS region to use for all resources"
  type        = string
}

variable "global_name" {
  description = "Global name of this project/account with environment"
  type        = string
}

variable "global_project" {
  description = "Global name of this project (without environment)"
  type        = string
}

variable "local_environment" {
  description = "Local name of this environment (eg, prod, stage, dev, feature1)"
  type        = string
}

variable "cloudwatch_enabled" {
  description = "The boolean flag whether this module is enabled or not. No resources are created when set to false."
  type        = bool
}

variable "alarm_namespace" {
  description = "The namespace in which all alarms are set up."
  type        = string
  default     = ""
}

variable "cloudtrail_log_group_name" {
  description = "The name of the CloudWatch Logs group to which CloudTrail events are delivered."
  type        = string
  default     = ""
}

variable "sns_topic_name" {
  description = "The name of the SNS Topic which will be notified when any alarm is performed."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Map of tags to assign to aws secuirty model"
  type        = map(string)
  default     = {}
}

variable "cloudtrail_enabled" {
  description = "The boolean flag whether this module is enabled or not. No resources are created when set to false."
  type        = bool
}

variable "aws_account_id" {
  description = "The AWS Account ID number of the account."
  type        = string
  default     = ""
}

variable "cloudtrail_name" {
  description = "The name of the trail."
  type        = string
  default     = ""
}

variable "cloudtrail_sns_topic_name" {
  description = "The sns topic linked to the cloudtrail"
  type        = string
  default     = ""
}



variable "cloudwatch_logs_retention_in_days" {
  description = "Number of days to retain logs for. CIS recommends 365 days.  Possible values are: 0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653. Set to 0 to keep logs indefinitely."
  type        = number
  default     = 365
}

variable "cloud_trail_iam_role_name" {
  description = "The name of the IAM Role to be used by CloudTrail to delivery logs to CloudWatch Logs group."
  type        = string
  default     = ""
}


variable "cloud_trail_iam_role_policy_name" {
  description = "The name of the IAM Role Policy to be used by CloudTrail to delivery logs to CloudWatch Logs group."
  type        = string
  default     = ""
}

variable "key_deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days."
  type        = number
  default     = 10
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket which will store configuration snapshots."
  default     = ""
}

variable "s3_key_prefix" {
  description = "The prefix for the specified S3 bucket."
  type        = string
  default     = ""
}

variable "is_organization_trail" {
  description = "Specifies whether the trail is an AWS Organizations trail. Organization trails log events for the master account and all member accounts. Can only be created in the organization master account."
  type        = bool
}



variable "aws_config_enabled" {
  description = "The boolean flag whether this module is enabled or not. No resources are created when set to false."
  type        = bool
}

variable "aws_config_iam_role_arn" {
  description = "The ARN of the IAM Role which AWS Config will use."
  type        = string
  default     = ""

}


variable "aws_config_sns_topic_name" {
  description = "The name of the SNS Topic to be used to notify configuration changes."
  type        = string
  default     = ""
}

variable "delivery_frequency" {
  description = "The frequency which AWS Config sends a snapshot into the S3 bucket."
  type        = string
  default     = ""
}

variable "recorder_name" {
  description = "The name of the configuration recorder."
  type        = string
  default     = ""
}

variable "delivery_channel_name" {
  description = "The name of the delivery channel."
  type        = string
  default     = ""
}

variable "include_global_resource_types" {
  description = "Specifies whether AWS Config includes all supported types of global resources with the resources that it records."
  type        = bool
}

variable "guard_duty_enabled" {
  description = "The boolean flag whether this module is enabled or not. No resources are created when set to false."
  type        = bool
  default     = true
}

variable "disable_email_notification" {
  description = "Boolean whether an email notification is sent to the accounts."
  type        = bool
  default     = false
}

variable "finding_publishing_frequency" {
  description = "Specifies the frequency of notifications sent for subsequent finding occurrences."
  type        = string
  default     = "SIX_HOURS"
}

variable "invitation_message" {
  description = "Message for invitation."
  type        = string
  default     = "This is an automatic invitation message from guardduty-baseline module."
}

variable "master_account_id" {
  description = "AWS account ID for master account."
  type        = string
  default     = ""
}

variable "member_accounts" {
  description = "A list of IDs and emails of AWS accounts which associated as member accounts."
  type = list(object({
    account_id = string
    email      = string
  }))
  default = []
}

variable "master_iam_role_enabled" {
  description = "Indicate if Terraform will create/update/delete the manager IAM role."
  type        = bool
  default     = true
}

variable "master_iam_role_name" {
  description = "The name of the IAM Master role."
  type        = string
  default     = "IAM-Master"
}

variable "master_iam_role_policy_name" {
  description = "The name of the IAM Master role policy."
  type        = string
  default     = "IAM-Master-Policy"
}

variable "master_iam_role_policy_json" {
  description = "Custom json to use for the role policy. The default allows management of users, groups, and roles."
  type        = string
  default     = ""
}

variable "master_iam_role_permissions_boundary_arn" {
  description = "Permissions boundary arn to attach to the master IAM role."
  type        = string
  default     = ""
}

variable "manager_iam_role_enabled" {
  description = "Indicate if Terraform will create/update/delete the manager IAM role."
  type        = bool
  default     = true

}

variable "manager_iam_role_name" {
  description = "The name of the IAM Manager role."
  type        = string
  default     = "IAM-Manager"
}

variable "manager_iam_role_policy_name" {
  description = "The name of the IAM Manager role policy."
  type        = string
  default     = "IAM-Manager-Policy"
}

variable "manager_iam_role_policy_json" {
  description = "Custom json to use for the role policy. The default allows the (dis)association of users and groups."
  type        = string
  default     = ""
}

variable "manager_iam_role_permissions_boundary_arn" {
  description = "Permissions boundary arn to attach to the manager IAM role."
  type        = string
  default     = ""
}

variable "support_iam_role_name" {
  description = "The name of the the support role."
  type        = string
  default     = "IAM-Support"
}

variable "support_iam_role_policy_name" {
  description = "The name of the support role policy."
  type        = string
  default     = "IAM-Support-Role"
}

variable "support_iam_role_principal_arns" {
  type        = list(string)
  description = "List of ARNs of the IAM principal elements by which the support role could be assumed."
  default     = []
}

variable "support_iam_role_permissions_boundary_arn" {
  description = "Permissions boundary arn to attach to the support IAM role."
  type        = string
  default     = ""
}

variable "max_password_age" {
  description = "The number of days that an user password is valid."
  type        = number
  default     = 90
}

variable "minimum_password_length" {
  description = "Minimum length to require for user passwords."
  type        = number
  default     = 14
}

variable "password_reuse_prevention" {
  description = "The number of previous passwords that users are prevented from reusing."
  type        = number
  default     = 24
}

variable "require_lowercase_characters" {
  description = "Whether to require lowercase characters for user passwords."
  type        = bool
  default     = true
}

variable "require_numbers" {
  description = "Whether to require numbers for user passwords."
  type        = bool
  default     = true
}

variable "require_uppercase_characters" {
  description = "Whether to require uppercase characters for user passwords."
  type        = bool
  default     = true
}

variable "require_symbols" {
  description = "Whether to require symbols for user passwords."
  type        = bool
  default     = true
}

variable "allow_users_to_change_password" {
  description = "Whether to allow users to change their own password."
  type        = bool
  default     = true
}

variable "secure_log_bucket_name" {
  description = "s3 security bucket name"
  type        = string
  default     = ""
}

variable "lifecycle_glacier_transition_days" {
  description = "The number of days after object creation when the object is archived into Glacier."
  type        = number
  default     = 30
}

variable "force_destroy" {
  description = " A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

variable "secure_bucket_enabled" {
  description = "A boolean that indicates this module is enabled. Resources are not created if it is set to false."
  type        = bool
  default     = true
}

variable "vpc_logs_enabled" {
  description = "The boolean flag whether this module is enabled or not. No resources are created when set to false."
  type        = bool
  default     = true
}

variable "vpc_log_group_name" {
  description = "The name of CloudWatch Logs group to which VPC Flow Logs are delivered."
  default     = ""
}

variable "vpc_flow_logs_iam_role_arn" {
  description = "The ARN of the IAM Role which will be used by VPC Flow Logs."
  type        = string
  default     = ""
}

variable "vpc_log_retention_in_days" {
  description = "Number of days to retain logs for. CIS recommends 365 days.  Possible values are: 0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653. Set to 0 to keep logs indefinitely."
  type        = string
  default     = ""
}

variable "s3_bucket_expiration_days" {
  description = "Specifies a period in the object's expire"
  type        = number
  default     = 365
}

variable "eip_attached_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "iam_password_policy_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "iam_user_no_policies_check_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "root_account_mfa_enabled_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "s3_bucket_ssl_requests_only_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "ebs_encrypted_volumes_check_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "sg_ssh_restricted_check_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "sg_unrestricted_common_ports_check_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "ec2_unused_ebs_volumes_check_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "ebs_snapshots_not_publicly_restorable_check_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "ec2_stopped_instances_check_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "ec2_instance_managed_by_systems_manager_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "default_security_group_closed_check_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "sg_atatched_to_eni_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "sg_open_to_specific_ports_only_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "s3_public_read_disable_check_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "s3_public_write_disable_check_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "s3_sse_enabled_check_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "rds_instance_public_access_check_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "db_instance_backup_enabled_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "rds_snapshots_public_prohibited_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "rds_multi_az_support_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "rds_storage_encrypted_rule_enabled" {
  description = "AWS Config rule"
  type        = bool
  default     = true
}

variable "iam_credentials_report_enabled" {
  description = "The boolean flag whether this module is enabled or not. No resources are created when set to false."
  type        = bool
  default     = false
}

variable "iam_credentials_sns_topic_arn" {
  description = "ARN of SNS Topic to be used to notify IAM credentials report result."
  type        = string
}

variable "iam_credentials_s3_bucket_name" {
  description = "The name of the S3 Bucket to be used to save IAM credentials report result."
  type        = string
  default     = "IamGenerateIamReport"
}

variable "iam_credentials_s3_file_name" {
  description = "The name of the file in S3 Bucket to be used to save IAM credentials report result."
  type        = string
  default     = "iam_credentials_report.csv"
}

variable "config_rules_report_enabled" {
  description = "The boolean flag whether this module is enabled or not. No resources are created when set to false."
  type        = bool
  default     = false
}

variable "config_rules_sns_topic_arn" {
  description = "ARN of SNS Topic to be used to notify IAM credentials report result."
  type        = string
}
