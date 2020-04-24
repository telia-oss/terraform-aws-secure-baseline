resource "aws_config_config_rule" "eip_attached" {
  name        = "eip_attached"
  description = "A Config rule that checks whether all Elastic IP addresses that are allocated to a VPC are attached to EC2 instances or in-use elastic network interfaces (ENIs)."
  count       = var.eip_attached_rule_enabled ? 1 : 0

  source {
    owner             = "AWS"
    source_identifier = "EIP_ATTACHED"
  }

  scope {
    compliance_resource_types = ["AWS::EC2::EIP"]
  }

  depends_on = [module.secure-baseline_config-baseline]
}

resource "aws_config_config_rule" "iam_password_policy" {
  count = var.iam_password_policy_rule_enabled ? 1 : 0
  name  = "iam_password_policy"

  source {
    owner             = "AWS"
    source_identifier = "IAM_PASSWORD_POLICY"
  }

  input_parameters = <<EOF
{
  "RequireUppercaseCharacters" : "true",
  "RequireLowercaseCharacters" : "true",
  "RequireSymbols" : "true",
  "RequireNumbers" : "true",
  "MinimumPasswordLength" : "16",
  "PasswordReusePrevention" : "12",
  "MaxPasswordAge" : "30"
}
EOF

  depends_on = [module.secure-baseline_config-baseline]
}


resource "aws_config_config_rule" "iam_user_no_policies_check" {
  name        = "iam_user_no_policies_check"
  description = "Checks that none of your IAM users have policies attached. IAM users must inherit permissions from IAM groups or roles."
  count       = var.iam_user_no_policies_check_rule_enabled ? 1 : 0

  source {
    owner             = "AWS"
    source_identifier = "IAM_USER_NO_POLICIES_CHECK"
  }

  depends_on = [module.secure-baseline_config-baseline]
}

resource "aws_config_config_rule" "root_account_mfa_enabled" {
  count = var.root_account_mfa_enabled_rule_enabled ? 1 : 0

  name        = "root_account_mfa_enabled"
  description = "Checks whether users of your AWS account require a multi-factor authentication (MFA) device to sign in with root credentials."

  source {
    owner             = "AWS"
    source_identifier = "ROOT_ACCOUNT_MFA_ENABLED"
  }

  depends_on = [module.secure-baseline_config-baseline]
}

resource "aws_config_config_rule" "s3_bucket_ssl_requests_only" {
  count = var.s3_bucket_ssl_requests_only_rule_enabled ? 1 : 0

  name        = "s3_bucket_ssl_requests_only"
  description = "Checks whether S3 buckets have policies that require requests to use Secure Socket Layer (SSL)."

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SSL_REQUESTS_ONLY"
  }

  depends_on = [module.secure-baseline_config-baseline]
}

resource "aws_config_config_rule" "ebs_encrypted_volumes_check" {
  count = var.ebs_encrypted_volumes_check_rule_enabled ? 1 : 0

  name        = "encrypted-volumes"
  description = "A Config rule that checks whether the EBS volumes that are in an attached state are encrypted."

  source {
    owner             = "AWS"
    source_identifier = "ENCRYPTED_VOLUMES"
  }
  scope {
    compliance_resource_types = ["AWS::EC2::Volume"]
  }

  depends_on = [module.secure-baseline_config-baseline]
}

resource "aws_config_config_rule" "sg_ssh_restricted_check" {
  count = var.sg_ssh_restricted_check_rule_enabled ? 1 : 0

  name        = "restricted-ssh"
  description = "A Config rule that checks whether security groups in use do not allow restricted incoming SSH traffic. This rule applies only to IPv4."

  source {
    owner             = "AWS"
    source_identifier = "INCOMING_SSH_DISABLED"
  }
  scope {
    compliance_resource_types = ["AWS::EC2::SecurityGroup"]
  }

  depends_on = [module.secure-baseline_config-baseline]
}

resource "aws_config_config_rule" "sg_unrestricted_common_ports_check" {
  count = var.sg_unrestricted_common_ports_check_rule_enabled ? 1 : 0

  name             = "restricted-common-ports"
  description      = "A Config rule that checks whether security groups in use do not allow restricted incoming TCP traffic to the specified ports. This rule applies only to IPv4."
  input_parameters = "{\"blockedPort1\":\"20\",\"blockedPort2\":\"21\",\"blockedPort3\":\"3389\",\"blockedPort4\":\"3306\",\"blockedPort5\":\"4333\"}"

  source {
    owner             = "AWS"
    source_identifier = "RESTRICTED_INCOMING_TRAFFIC"
  }
  scope {
    compliance_resource_types = ["AWS::EC2::SecurityGroup"]
  }

  depends_on = [module.secure-baseline_config-baseline]
}

resource "aws_config_config_rule" "ec2_unused_ebs_volumes_check" {
  count = var.ec2_unused_ebs_volumes_check_rule_enabled ? 1 : 0

  name        = "ec2-volume-inuse-check"
  description = "A Config rule that checks whether EBS volumes are attached to EC2 instances. Optionally checks if EBS volumes are marked for deletion when an instance is terminated."

  source {
    owner             = "AWS"
    source_identifier = "EC2_VOLUME_INUSE_CHECK"
  }
  scope {
    compliance_resource_types = ["AWS::EC2::Volume"]
  }

  depends_on = [module.secure-baseline_config-baseline]
}

resource "aws_config_config_rule" "ebs_snapshots_not_publicly_restorable_check" {
  count = var.ebs_snapshots_not_publicly_restorable_check_rule_enabled ? 1 : 0

  name        = "ebs-snapshot-public-restorable-check"
  description = "A Config rule that checks whether Amazon Elastic Block Store snapshots are not publicly restorable. The rule is NON_COMPLIANT if one or more snapshots with the RestorableByUserIds field is set to all."

  source {
    owner             = "AWS"
    source_identifier = "EBS_SNAPSHOT_PUBLIC_RESTORABLE_CHECK"
  }
  scope {
    compliance_resource_types = []
  }

  depends_on = [module.secure-baseline_config-baseline]
}

resource "aws_config_config_rule" "ec2_stopped_instances_check" {
  count = var.ec2_stopped_instances_check_rule_enabled ? 1 : 0

  name             = "ec2-stopped-instance"
  description      = "A Config rule that checks whether there are instances stopped for more than the allowed number of days. The instance is NON_COMPLIANT if the state of the ec2 instance has been stopped for longer than the allowed number of days."
  input_parameters = "{\"AllowedDays\":\"30\"}"

  source {
    owner             = "AWS"
    source_identifier = "EC2_STOPPED_INSTANCE"
  }
  scope {
    compliance_resource_types = []
  }

  depends_on = [module.secure-baseline_config-baseline]
}

resource "aws_config_config_rule" "ec2_instance_managed_by_systems_manager" {
  count = var.ec2_instance_managed_by_systems_manager_rule_enabled ? 1 : 0

  name        = "ec2-instance-managed-by-systems-manager"
  description = "A Config rule that checks whether the Amazon EC2 instances in your account are managed by AWS Systems Manager."

  source {
    owner             = "AWS"
    source_identifier = "EC2_INSTANCE_MANAGED_BY_SSM"
  }
  scope {
    compliance_resource_types = ["AWS::EC2::Instance", "AWS::SSM::ManagedInstanceInventory"]
  }

  depends_on = [module.secure-baseline_config-baseline]
}


resource "aws_config_config_rule" "default_security_group_closed_check" {
  count = var.default_security_group_closed_check_rule_enabled ? 1 : 0

  name        = "vpc-default-security-group-closed"
  description = "A config rule that checks that the default security group of any Amazon Virtual Private Cloud (VPC) does not allow inbound or outbound traffic. The rule returns NOT_APPLICABLE if the security group is not default. The rule is NON_COMPLIANT if the default"

  source {
    owner             = "AWS"
    source_identifier = "VPC_DEFAULT_SECURITY_GROUP_CLOSED"
  }
  scope {
    compliance_resource_types = ["AWS::EC2::SecurityGroup"]
  }

  depends_on = [module.secure-baseline_config-baseline]
}

resource "aws_config_config_rule" "sg_atatched_to_eni" {
  count = var.sg_atatched_to_eni_rule_enabled ? 1 : 0

  name        = "ec2-security-group-attached-to-eni"
  description = "A Config rule that checks that security groups are attached to Amazon Elastic Compute Cloud (Amazon EC2) instances or an elastic network interfaces (ENIs). The rule returns NON_COMPLIANT if the security group is not associated with an Amazon EC2 instance"

  source {
    owner             = "AWS"
    source_identifier = "EC2_SECURITY_GROUP_ATTACHED_TO_ENI"
  }
  scope {
    compliance_resource_types = ["AWS::EC2::SecurityGroup"]
  }

  depends_on = [module.secure-baseline_config-baseline]
}

resource "aws_config_config_rule" "sg_open_to_specific_ports_only" {
  count = var.sg_open_to_specific_ports_only_rule_enabled ? 1 : 0

  name        = "vpc-sg-open-only-to-authorized-ports"
  description = "A Config rule that checks whether the security group with 0.0.0.0/0 of any Amazon Virtual Private Cloud (Amazon VPCs) allows only specific inbound TCP or UDP traffic. The rule and any security group with inbound 0.0.0.0/0. is NON_COMPLIANT, if you do n..."

  source {
    owner             = "AWS"
    source_identifier = "VPC_SG_OPEN_ONLY_TO_AUTHORIZED_PORTS"
  }
  scope {
    compliance_resource_types = ["AWS::EC2::SecurityGroup"]
  }

  depends_on = [module.secure-baseline_config-baseline]
}

resource "aws_config_config_rule" "s3_public_read_disable_check" {
  count = var.s3_public_read_disable_check_rule_enabled ? 1 : 0

  name        = "s3-bucket-public-read-prohibited"
  description = "A Config rule that checks that your Amazon S3 buckets do not allow public read access. If an Amazon S3 bucket policy or bucket ACL allows public read access, the bucket is noncompliant."

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }
  scope {
    compliance_resource_types = ["AWS::S3::Bucket"]
  }

  depends_on = [module.secure-baseline_config-baseline]
}

resource "aws_config_config_rule" "s3_public_write_disable_check" {
  count = var.s3_public_write_disable_check_rule_enabled ? 1 : 0

  name        = "s3-bucket-public-write-prohibited"
  description = "A Config rule that checks that your Amazon S3 buckets do not allow public write access. If an Amazon S3 bucket policy or bucket ACL allows public write access, the bucket is noncompliant."

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
  }
  scope {
    compliance_resource_types = ["AWS::S3::Bucket"]
  }

  depends_on = [module.secure-baseline_config-baseline]
}

resource "aws_config_config_rule" "s3_sse_enabled_check" {
  count = var.s3_sse_enabled_check_rule_enabled ? 1 : 0

  name        = "s3-bucket-server-side-encryption-enabled"
  description = "A Config rule that checks that your Amazon S3 bucket either has Amazon S3 default encryption enabled or that the S3 bucket policy explicitly denies put-object requests without server side encryption."

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
  }
  scope {
    compliance_resource_types = ["AWS::S3::Bucket"]
  }

  depends_on = [module.secure-baseline_config-baseline]
}

resource "aws_config_config_rule" "rds_instance_public_access_check" {
  count = var.rds_instance_public_access_check_rule_enabled ? 1 : 0

  name        = "rds-instance-public-access-check"
  description = "A config rule that checks whether the Amazon Relational Database Service instances are not publicaly accessible. The rule is NON_COMPLIANT if the publiclyAccessible field is true in the instance configuration item."

  source {
    owner             = "AWS"
    source_identifier = "RDS_INSTANCE_PUBLIC_ACCESS_CHECK"
  }
  scope {
    compliance_resource_types = ["AWS::RDS::DBInstance"]
  }

  depends_on = [module.secure-baseline_config-baseline]
}

resource "aws_config_config_rule" "db_instance_backup_enabled" {
  count = var.db_instance_backup_enabled_rule_enabled ? 1 : 0

  name        = "db-instance-backup-enabled"
  description = "A config rule that checks whether RDS DB instances have backups enabled. Optionally, the rule checks the backup retention period and the backup window."

  source {
    owner             = "AWS"
    source_identifier = "DB_INSTANCE_BACKUP_ENABLED"
  }
  scope {
    compliance_resource_types = ["AWS::RDS::DBInstance"]
  }

  depends_on = [module.secure-baseline_config-baseline]
}

resource "aws_config_config_rule" "rds_snapshots_public_prohibited" {
  count = var.rds_snapshots_public_prohibited_rule_enabled ? 1 : 0

  name        = "rds-snapshots-public-prohibited"
  description = "A Config rule that checks if Amazon Relational Database Service (Amazon RDS) snapshots are public. The rule is non-compliant if any existing and new Amazon RDS snapshots are public."

  source {
    owner             = "AWS"
    source_identifier = "RDS_SNAPSHOTS_PUBLIC_PROHIBITED"
  }
  scope {
    compliance_resource_types = ["AWS::RDS::DBSnapshot"]
  }

  depends_on = [module.secure-baseline_config-baseline]
}

resource "aws_config_config_rule" "rds_multi_az_support" {
  count = var.rds_multi_az_support_rule_enabled ? 1 : 0

  name        = "rds-multi-az-support"
  description = "A Config rule that checks whether high availability is enabled for your RDS DB instances. (Note: This rule does not evaluate Amazon Aurora databases.)"

  source {
    owner             = "AWS"
    source_identifier = "RDS_MULTI_AZ_SUPPORT"
  }
  scope {
    compliance_resource_types = ["AWS::RDS::DBInstance"]
  }

  depends_on = [module.secure-baseline_config-baseline]
}

resource "aws_config_config_rule" "rds_storage_encrypted" {
  count = var.rds_storage_encrypted_rule_enabled ? 1 : 0

  name        = "rds-storage-encrypted"
  description = "A Config rule that checks whether storage encryption is enabled for your RDS DB instances."

  source {
    owner             = "AWS"
    source_identifier = "RDS_STORAGE_ENCRYPTED"
  }
  scope {
    compliance_resource_types = ["AWS::RDS::DBInstance"]
  }

  depends_on = [module.secure-baseline_config-baseline]
}




