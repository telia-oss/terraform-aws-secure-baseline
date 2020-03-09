#Secure-baseline module

This module enables basic security services in AWS.


| AWS Config Rule name | Description |
| --- | --- |
| eip_attached | A Config rule that checks whether all Elastic IP addresses that are allocated to a VPC are attached to EC2 instances or in-use elastic network interfaces (ENIs). |
| iam_user_no_policies_check | Checks that none of your IAM users have policies attached. IAM users must inherit permissions from IAM groups or roles. |
| root_account_mfa_enabled | Checks whether users of your AWS account require a multi-factor authentication (MFA) device to sign in with root credentials. |
| s3_bucket_ssl_requests_only| Checks whether S3 buckets have policies that require requests to use Secure Socket Layer (SSL)."  |
| encrypted-volumes| A Config rule that checks whether the EBS volumes that are in an attached state are encrypted.  |
| restricted-ssh | A Config rule that checks whether security groups in use do not allow restricted incoming SSH traffic. This rule applies only to IPv4. |
| restricted-common-ports| A Config rule that checks whether security groups in use do not allow restricted incoming TCP traffic to the specified ports. This rule applies only to IPv4. |
| ec2-volume-inuse-check |  A Config rule that checks whether EBS volumes are attached to EC2 instances. Optionally checks if EBS volumes are marked for deletion when an instance is terminated. |
| ebs-snapshot-public-restorable-check | A Config rule that checks whether Amazon Elastic Block Store snapshots are not publicly restorable. The rule is NON_COMPLIANT if one or more snapshots with the RestorableByUserIds field is set to all. |
| ec2-stopped-instance | A Config rule that checks whether there are instances stopped for more than the allowed number of days. The instance is NON_COMPLIANT if the state of the ec2 instance has been stopped for longer than the allowed number of days. |
| ec2-instance-managed-by-systems-manager | A Config rule that checks whether the Amazon EC2 instances in your account are managed by AWS Systems Manager. |
| vpc-default-security-group-closed | A config rule that checks that the default security group of any Amazon Virtual Private Cloud (VPC) does not allow inbound or outbound traffic. The rule returns NOT_APPLICABLE if the security group is not default. The rule is NON_COMPLIANT if the default |
| ec2-security-group-attached-to-eni | A Config rule that checks that security groups are attached to Amazon Elastic Compute Cloud (Amazon EC2) instances or an elastic network interfaces (ENIs). The rule returns NON_COMPLIANT if the security group is not associated with an Amazon EC2 instance |
| vpc-sg-open-only-to-authorized-ports | A Config rule that checks whether the security group with 0.0.0.0/0 of any Amazon Virtual Private Cloud (Amazon VPCs) allows only specific inbound TCP or UDP traffic. The rule and any security group with inbound 0.0.0.0/0. is NON_COMPLIANT |
| s3-bucket-public-read-prohibited | A Config rule that checks that your Amazon S3 buckets do not allow public read access. If an Amazon S3 bucket policy or bucket ACL allows public read access, the bucket is noncompliant. |
| s3-bucket-public-write-prohibited | A Config rule that checks that your Amazon S3 buckets do not allow public write access. If an Amazon S3 bucket policy or bucket ACL allows public write access, the bucket is noncompliant. |
| s3-bucket-server-side-encryption-enabled |  A Config rule that checks that your Amazon S3 bucket either has Amazon S3 default encryption enabled or that the S3 bucket policy explicitly denies put-object requests without server side encryption. |
| rds-instance-public-access-check | A config rule that checks whether the Amazon Relational Database Service instances are not publicaly accessible. The rule is NON_COMPLIANT if the publiclyAccessible field is true in the instance configuration item. |
| db-instance-backup-enabled | A config rule that checks whether RDS DB instances have backups enabled. Optionally, the rule checks the backup retention period and the backup window. |
| rds-snapshots-public-prohibited | A Config rule that checks if Amazon Relational Database Service (Amazon RDS) snapshots are public. The rule is non-compliant if any existing and new Amazon RDS snapshots are public. |
| rds-multi-az-support | A Config rule that checks whether high availability is enabled for your RDS DB instances. (Note: This rule does not evaluate Amazon Aurora databases.) |
| rds-storage-encrypted | A Config rule that checks whether storage encryption is enabled for your RDS DB instances. |
| rds_vpc_public_subnet | A Config rule that checks that no RDS Instances are in Public Subnet. |
