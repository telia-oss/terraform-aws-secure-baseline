data "archive_file" "lambda_zip_inline_LambdaFunctionIamReport" {
  type        = "zip"
  output_path = "${path.module}/lambda_iam_report.zip"

  source {
    filename = "iam_generate_extended_credentials_report.py"
    content  = file("${path.module}/lambda_src/iam_generate_extended_credentials_report.py")

  }
}

resource "aws_lambda_function" "LambdaFunctionIamReport" {
  count            = var.iam_credentials_report_enabled ? 1 : 0
  function_name    = "LambdaFunction_iam_extended_credentials_report"
  timeout          = "300"
  runtime          = "python3.6"
  handler          = "iam_generate_extended_credentials_report.lambda_handler"
  role             = aws_iam_role.LambdaIamGenerateIamReport[count.index].arn
  filename         = data.archive_file.lambda_zip_inline_LambdaFunctionIamReport.output_path
  source_code_hash = data.archive_file.lambda_zip_inline_LambdaFunctionIamReport.output_base64sha256
  environment {
    variables = {
      SNS_TOPIC_ARN = var.iam_credentials_sns_topic_arn,
      BUCKET_NAME   = var.iam_credentials_s3_bucket_name,
      BUCKET_KEY    = var.iam_credentials_s3_file_name
    }
  }
}

resource "aws_lambda_permission" "LambdaPermissionIamReport" {
  count         = var.iam_credentials_report_enabled ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.LambdaFunctionIamReport[count.index].function_name
  principal     = "config.amazonaws.com"
}

resource "aws_iam_role" "LambdaIamGenerateIamReport" {
  count              = var.iam_credentials_report_enabled ? 1 : 0
  name               = "IamRole_iam_extended_credentials_report"
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

resource "aws_iam_role_policy_attachment" "LambdaIamRoleIamReportManagedPolicyRoleAttachment0" {
  count      = var.iam_credentials_report_enabled ? 1 : 0
  role       = aws_iam_role.LambdaIamGenerateIamReport[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "LambdaIamRoleIamReportManagedPolicyRoleAttachment1" {
  count      = var.iam_credentials_report_enabled ? 1 : 0
  role       = aws_iam_role.LambdaIamGenerateIamReport[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "sns-publish-policy" {
  name        = "sns publish"
  description = "SNS publish policy"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
  {
    "Sid": "sns publish",
    "Effect": "Allow",
    "Principal": {
    "AWS": "${aws_iam_role.LambdaIamGenerateIamReport[0].arn}"
      },
    "Action": ["sns:Publish"],
    "Resource":   "${var.iam_credentials_sns_topic_arn}"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "LambdaIamRoleIamReportManagedPolicyRoleAttachment2" {
  count      = var.iam_credentials_report_enabled ? 1 : 0
  role       = aws_iam_role.LambdaIamGenerateIamReport[count.index].name
  policy_arn = aws_iam_policy.sns_publish_policy
}

resource "aws_s3_bucket" "IamGenerateIamReport" {
  count  = var.iam_credentials_report_enabled ? 1 : 0
  bucket = var.iam_credentials_s3_bucket_name
  acl    = "private"

  logging {
    target_bucket = var.iam_credentials_s3_bucket_name
    target_prefix = "${var.s3_key_prefix}-iam-report"
  }
}

resource "aws_s3_bucket_policy" "IamGenerateIamReportS3Policy" {
  count  = var.iam_credentials_report_enabled ? 1 : 0
  bucket = var.iam_credentials_s3_bucket_name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowS3BucketAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.LambdaIamGenerateIamReport[count.index].arn}"
      },
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::${var.iam_credentials_s3_bucket_name}",
        "arn:aws:s3:::${var.iam_credentials_s3_bucket_name}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_cloudwatch_event_rule" "every_half_year" {
  count               = var.iam_credentials_report_enabled ? 1 : 0
  name                = "every-half-year"
  description         = "Fires every 6 months"
  schedule_expression = "rate(182 days)"
}

resource "aws_cloudwatch_event_target" "check_every_half_year" {
  count     = var.iam_credentials_report_enabled ? 1 : 0
  rule      = aws_cloudwatch_event_rule.every_half_year[count.index].arn
  target_id = "lambda"
  arn       = aws_lambda_function.LambdaFunctionIamReport[count.index].arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_iam_report" {
  count         = var.iam_credentials_report_enabled ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.LambdaFunctionIamReport[count.index].arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_half_year[count.index].arn
}
