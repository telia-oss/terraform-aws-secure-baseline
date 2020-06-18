resource "aws_config_config_rule" "no_rds_snapshots_in_past_day_check" {
  name        = "rds_snapshots"
  description = "A Config rule that checks that no RDS Instances is having snapshots older than day."
  depends_on  = [aws_lambda_permission.LambdaPermissionConfigRule, module.secure-baseline_config-baseline]

  scope {
    compliance_resource_types = ["AWS::RDS::DBInstance"]
  }
  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = aws_lambda_function.RDSSnapshotLambdaFunctionConfigRule.arn
    source_detail {
      event_source                = "aws.config"
      message_type                = "ScheduledNotification"
      maximum_execution_frequency = "One_Hour"
    }
  }
}

data "archive_file" "lambda_zip_inline_RDSSnapshotLambdaFunctionConfigRule" {
  type        = "zip"
  output_path = "${path.module}/RDSSnapshotLambdaFunctionConfigRule.zip"

  source {
    filename = "index.py"
    content  = "${file("${path.module}/custom_lambda_rules/no_rds_snapshots_in_past_day.py")}"

  }
}

resource "aws_lambda_function" "RDSSnapshotLambdaFunctionConfigRule" {
  function_name    = "RDSSnapshotAWSConfigRuleCheck"
  timeout          = "300"
  runtime          = "python3.6"
  handler          = "index.lambda_handler"
  role             = aws_iam_role.RDSSnapshotLambdaIamRoleConfigRule.arn
  filename         = data.archive_file.lambda_zip_inline_RDSSnapshotLambdaFunctionConfigRule.output_path
  source_code_hash = data.archive_file.lambda_zip_inline_RDSSnapshotLambdaFunctionConfigRule.output_base64sha256

  vpc_config {
    security_group_ids = var.custom_lambda_vpc_security_group_ids
    subnet_ids         = var.custom_lambda_vpc_private_subnets
  }
}

resource "aws_lambda_permission" "RDSSnapshotLambdaPermissionConfigRule" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.RDSSnapshotLambdaFunctionConfigRule.function_name
  principal     = "config.amazonaws.com"
}

resource "aws_iam_role" "RDSSnapshotLambdaIamRoleConfigRule" {
  name               = "RDSSnapshotAWSConfigRule"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["lambda.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "RDSSnapshotLambdaIamRoleConfigRuleManagedPolicyRoleAttachment0" {
  role       = aws_iam_role.RDSSnapshotLambdaIamRoleConfigRule.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "RDSSnapshotLambdaIamRoleConfigRuleManagedPolicyRoleAttachment1" {
  role       = aws_iam_role.RDSSnapshotLambdaIamRoleConfigRule.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRulesExecutionRole"
}

resource "aws_iam_role_policy_attachment" "RDSSnapshotLambdaIamRoleConfigRuleManagedPolicyRoleAttachment2" {
  role       = aws_iam_role.RDSSnapshotLambdaIamRoleConfigRule.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "RDSSnapshotLambdaIamRoleConfigRuleManagedPolicyRoleAttachment3" {
  role       = aws_iam_role.RDSSnapshotLambdaIamRoleConfigRule.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSReadOnlyAccess"
}