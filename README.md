# Secure-baseline module

This module sets up secure configurations in your AWS account. 

## Services

- Set up IAM Password Policy.
- Create separated IAM roles for defining privileges and assigning them to entities such as IAM users and groups.
- Enable CloudTrail in all regions and deliver events to CloudWatch Logs.
- CloudTrail logs are encrypted using AWS Key Management Service.
- All logs are stored in the S3 bucket with access logging enabled.
- Set up CloudWatch alarms to notify you when critical changes happen in your AWS account.
- Enable AWS Config in all regions to automatically take configuration snapshots.
- Enable SecurityHub and subscribe CIS benchmark standard.
- Enable VPC Flow Logs with the default VPC in all regions.
- Enable GuardDuty in all regions.

## Inputs

### Alarm-baseline: Set up CloudWatch alarms to notify you when critical changes happen in your AWS account.
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| cloudwatch\_enabled | The boolean flag whether this module is enabled or not. No resources are created when set to false. | `bool` | n/a | yes |
| alarm\_namespace | The namespace in which all alarms are set up. | `string` | n/a | yes |
| cloudtrail\_log\_group\_name | The name of the CloudWatch Logs group to which CloudTrail events are delivered. | `string` | n/a | yes |
| sns\_topic\_name | The name of the SNS Topic which will be notified when any alarm is performed. | `string` | n/a | yes |
| tags | Map of tags to assign to aws secuirty model | `map(string)` | `{}` | no |

### CloudTrail-baseline: Enable CloudTrail in all regions and deliver events to CloudWatch Logs.
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| cloudtrail\_enabled | The boolean flag whether this module is enabled or not. No resources are created when set to false. | `bool` | n/a | yes |
| aws\_account\_id | The AWS Account ID number of the account. | `any` | n/a | yes |
| cloudtrail\_name | The name of the trail. | `string` | n/a | yes |
| cloudtrail\_sns\_topic\_name | The sns topic linked to the cloudtrail | `string` | n/a | yes |
| cloudwatch\_logs\_retention\_in\_days | Number of days to retain logs for. CIS recommends 365 days.  Possible values are: 0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653. Set to 0 to keep logs indefinitely. | `number` | n/a | yes |
| cloud\_trail\_iam\_role\_name | The name of the IAM Role to be used by CloudTrail to delivery logs to CloudWatch Logs group. | `string` | n/a | yes |
| cloud\_trail\_iam\_role\_policy\_name | The name of the IAM Role Policy to be used by CloudTrail to delivery logs to CloudWatch Logs group. | `string` | n/a | yes |
| key\_deletion\_window\_in\_days | Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days. | `number` | n/a | yes |
| s3\_bucket\_name | The name of the S3 bucket which will store configuration snapshots. | `any` | n/a | yes |
| s3\_key\_prefix | The prefix for the specified S3 bucket. | `string` | n/a | yes |
| is\_organization\_trail | Specifies whether the trail is an AWS Organizations trail. Organization trails log events for the master account and all member accounts. Can only be created in the organization master account. | `bool` | n/a | yes |

### AWS Config-baseline: Enable AWS Config in all regions to automatically take configuration snapshots.
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws\_config\_enabled | The boolean flag whether this module is enabled or not. No resources are created when set to false. | `bool` | n/a | yes |
| aws\_config\_iam\_role\_arn | The ARN of the IAM Role which AWS Config will use. | `any` | n/a | yes |
| aws\_config\_sns\_topic\_name | The name of the SNS Topic to be used to notify configuration changes. | `string` | n/a | yes |
| delivery\_frequency | The frequency which AWS Config sends a snapshot into the S3 bucket. | `string` | n/a | yes |
| recorder\_name | The name of the configuration recorder. | `string` | n/a | yes |
| delivery\_channel\_name | The name of the delivery channel. | `string` | n/a | yes |
| include\_global\_resource\_types | Specifies whether AWS Config includes all supported types of global resources with the resources that it records. | `bool` | n/a | yes |


### GuardDuty-baseline: Enable GuardDuty in all regions.
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| guard\_duty\_enabled | The boolean flag whether this module is enabled or not. No resources are created when set to false. | `bool` | `true` | no |
| disable\_email\_notification | Boolean whether an email notification is sent to the accounts. | `bool` | `false` | no |
| finding\_publishing\_frequency | Specifies the frequency of notifications sent for subsequent finding occurrences. | `string` | `"SIX_HOURS"` | no |
| invitation\_message | Message for invitation. | `string` | `"This is an automatic invitation message from guardduty-baseline module."` | no |
| master\_account\_id | AWS account ID for master account. | `string` | `""` | no |
| member\_accounts | A list of IDs and emails of AWS accounts which associated as member accounts. | `list` object( account_id = `string`, email = `string` | `[]` | no |
 
 
### IAM-baseline: Set up IAM Password Policy and create default IAM roles for managing AWS account.
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:| 
| master\_iam\_role\_enabled | Indicate if Terraform will create/update/delete the manager IAM role. | `bool` | `true` | no |
| master\_iam\_role\_name | The name of the IAM Master role. | `string` | `"IAM-Master"` | no |
| master\_iam\_role\_permissions\_boundary\_arn | Permissions boundary arn to attach to the master IAM role. | `string` | `""` | no |
| master\_iam\_role\_policy\_json | Custom json to use for the role policy. The default allows management of users, groups, and roles. | `string` | `""` | no |
| master\_iam\_role\_policy\_name | The name of the IAM Master role policy. | `string` | `"IAM-Master-Policy"` | no |
| manager\_iam\_role\_enabled | Indicate if Terraform will create/update/delete the manager IAM role. | `string` | `"true"` | no |
| manager\_iam\_role\_name | The name of the IAM Manager role. | `string` | `"IAM-Manager"` | no |
| manager\_iam\_role\_permissions\_boundary\_arn | Permissions boundary arn to attach to the manager IAM role. | `string` | `""` | no |
| manager\_iam\_role\_policy\_json | Custom json to use for the role policy. The default allows the (dis)association of users and groups. | `string` | `""` | no |
| manager\_iam\_role\_policy\_name | The name of the IAM Manager role policy. | `string` | `"IAM-Manager-Policy"` | no |
| support\_iam\_role\_name | The name of the the support role. | `string` | `"IAM-Support"` | no |
| support\_iam\_role\_permissions\_boundary\_arn | Permissions boundary arn to attach to the support IAM role. | `string` | `""` | no |
| support\_iam\_role\_policy\_name | The name of the support role policy. | `string` | `"IAM-Support-Role"` | no |
| support\_iam\_role\_principal\_arns | List of ARNs of the IAM principal elements by which the support role could be assumed. | `list(string)` | `[]` | no |
| max\_password\_age | The number of days that an user password is valid. | `number` | `90` | no |
| minimum\_password\_length | Minimum length to require for user passwords. | `number` | `14` | no |
| password\_reuse\_prevention | The number of previous passwords that users are prevented from reusing. | `number` | `24` | no |
| require\_lowercase\_characters | Whether to require lowercase characters for user passwords. | `bool` | `true` | no |
| require\_numbers | Whether to require numbers for user passwords. | `bool` | `true` | no |
| require\_symbols | Whether to require symbols for user passwords. | `bool` | `true` | no |
| require\_uppercase\_characters | Whether to require uppercase characters for user passwords. | `bool` | `true` | no |
| allow\_users\_to\_change\_password | Whether to allow users to change their own password. | `bool` | `true` | no |

### S3-bucket: Creates a S3 bucket with access logging enabled.
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:| 
| secure\_bucket\_enabled | A boolean that indicates this module is enabled. Resources are not created if it is set to false. | `bool` | `true` | no |
| secure\_log\_bucket\_name | n/a | `any` | n/a | yes |
| lifecycle\_glacier\_transition\_days | The number of days after object creation when the object is archived into Glacier. | `number` | `30` | no |
| force\_destroy | A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. | `bool` | `false` | no |

### SecurityHub-baseline: Enable SecurityHub and subscribe CIS benchmark standard.

SecurityHub and CIS benchmark standard always enabled.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:| 
|securityhub\_pci\_standard\_enabled | A boolean that indicates PCI DSS standard is enabled. Resources are not created if it is set to false. | `bool` | `true` | no |
|securityhub\_aws\_standard\_enabled | A boolean that indicates AWS Foundational Security Best Practices standard is enabled. Resources are not created if it is set to false. | `bool` | `true` | no |


### VPC-baseline: Enable VPC Flow Logs with the default VPC in all regions.
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:| 
| vpc\_logs\_enabled | The boolean flag whether this module is enabled or not. No resources are created when set to false. | `bool` | `true` | no |
| vpc\_flow\_logs\_iam\_role\_arn | The ARN of the IAM Role which will be used by VPC Flow Logs. | `string` | `""` | no |
| vpc\_log\_group\_name | The name of CloudWatch Logs group to which VPC Flow Logs are delivered. | `string` | `""` | no |
| vpc\_log\_retention\_in\_days | Number of days to retain logs for. CIS recommends 365 days.  Possible values are: 0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653. Set to 0 to keep logs indefinitely. | `string` | `""` | no |

### AWS Config custom rules
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|  
| eip\_attached\_rule\_enabled | AWS Config rule | `bool` | `true` | no |
| iam\_user\_no\_policies\_check\_rule\_enabled | AWS Config rule | `bool` | `true` | no |
| ec2\_instance\_managed\_by\_systems\_manager\_rule\_enabled | AWS Config rule | `bool` | `true` | no |
| default\_security\_group\_closed\_check\_rule\_enabled | AWS Config rule | `bool` | `true` | no |
| sg\_atatched\_to\_eni\_rule\_enabled | AWS Config rule | `bool` | `true` | no |
| rds\_multi\_az\_support | AWS Config rule | `bool` | `true` | no |


### Overview of all AWS Config Rules
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
| rds_snapshots | A Config rule that checks that no RDS Instances is having snapshots older than day. |

### IAM credentials report: Enable IAM users credentials report.

Generates report in CSV format into specified S3 bucket and sends SNS notification.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:| 
|iam\_credentials\_report\_enabled | The boolean flag whether this module is enabled or not. No resources are created when set to false. | `bool` | `false` | no |
|iam\_credentials\_sns\_topic\_arn | ARN of SNS Topic to be used to notify IAM credentials report result. | `string` | `""` | yes |
|iam\_credentials\_s3\_bucket\_name | The name of the S3 Bucket to be used to save IAM credentials report result. | `string` | `IamGenerateIamReport` | no |
|iam\_credentials\_s3\_file\_name | The name of the file in S3 Bucket to be used to save IAM credentials report result. | `string` | `iam_credentials_report.csv` | no |

 ## Config rules report: Enable Config rules report.
 
 Generates non-compliant config rules report and sends SNS notification with details.
 
 | Name | Description | Type | Default | Required |
 |------|-------------|------|---------|:-----:| 
 |config\_rules\_report\_enabled | The boolean flag whether this module is enabled or not. No resources are created when set to false. | `bool` | `false` | no |
 |config\_rules\_sns\_topic\_arn | ARN of SNS Topic to be used to notify config rules report result. | `string` | `""` | yes |
 
 ## Custom config rules
  
  Custom config rules checking RDS via lambda functions.
  
  | Name | Description | Type | Default | Required |
  |------|-------------|------|---------|:-----:| 
  |custom\_lambda\_vpc_\security\_group\_ids | The list of custom lambda VPC security group ids. | `list(string)` | `[]` | no |
  |custom\_lambda\_vpc_\private\_subnets | The list of custom lambda VPC private subnets. | `list(string)` | `[]` | no | 

## Outputs

No output.

## Examples

- Basic: Terraform module which includes
    - AWS Config with rules
    - CloudTrail
    - CloudWatch
    - SecurityHub
    
- Complex: Terraform module which includes all security modules  

## Authors

Currently maintained by [these contributors](../../graphs/contributors).

## License

MIT License. See [LICENSE](LICENSE) for full details.