data "archive_file" "lambda_zip_inline_LambdaFunctionConfigRules" {
  type        = "zip"
  output_path = "${path.module}/lambda_config_rules.zip"

  source {
    filename = "config_generate_non-copliant_rules_report.py"
    content  = file("${path.module}/lambda_src/config_generate_non-copliant_rules_report.py")

  }
}
resource "aws_lambda_function" "LambdaFunctionConfigRules" {
  count            = var.config_rules_report_enabled ? 1 : 0
  function_name    = "LambdaFunction_config_rules_report"
  timeout          = "300"
  runtime          = "python3.7"
  handler          = "config_generate_non-copliant_rules_report.lambda_handler"
  role             = aws_iam_role.LambdaRoleConfigRules[count.index].arn
  filename         = data.archive_file.lambda_zip_inline_LambdaFunctionConfigRules.output_path
  source_code_hash = data.archive_file.lambda_zip_inline_LambdaFunctionConfigRules.output_base64sha256
  environment {
    variables = {
      SNS_TOPIC_ARN = var.config_rules_sns_topic_name,
    }
  }
}

resource "aws_lambda_permission" "LambdaPermissionConfigRules" {
  count         = var.config_rules_report_enabled ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.LambdaFunctionConfigRules[count.index].function_name
  principal     = "config.amazonaws.com"
}

resource "aws_iam_role" "LambdaRoleConfigRules" {
  count              = var.config_rules_report_enabled ? 1 : 0
  name               = "IamRole_config_rules_report"
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
    },
    {
      "Effect": "Allow",
      "Action": [
      "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::*/AWSLogs/*/Config/*"
    },
    {
      "Effect": "Allow",
      "Action": [
      "config:Describe*"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_cloudwatch_event_rule" "every_seven_days" {
  count               = var.config_rules_report_enabled ? 1 : 0
  name                = "every-seven-days"
  description         = "Fires every 7 days"
  schedule_expression = "rate(7 days)"
}

resource "aws_cloudwatch_event_target" "check_once_per_week" {
  count     = var.config_rules_report_enabled ? 1 : 0
  rule      = aws_cloudwatch_event_rule.every_seven_days[0].arn
  target_id = "lambda"
  arn       = aws_lambda_function.LambdaFunctionConfigRules[0].arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_config_rules" {
  count         = var.config_rules_report_enabled ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.LambdaFunctionConfigRules[0].arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_seven_days[0].arn
}
