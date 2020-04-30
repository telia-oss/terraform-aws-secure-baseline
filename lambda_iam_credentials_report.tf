data "archive_file" "lambda_zip_inline_LambdaFunctionIamReport" {
  type        = "zip"
  output_path = "${path.module}/lambda_iam_report.zip"

  source {
    filename = "iam_generate_extended_credentials_report.py"
    content  = file("${path.module}/lambda_src/iam_generate_extended_credentials_report.py")

  }
}

resource "aws_lambda_function" "LambdaFunctionIamReport" {
  function_name    = "LambdaFunction_iam_extended_credentials_report"
  timeout          = "300"
  runtime          = "python3.6"
  handler          = "iam_generate_extended_credentials_report.lambda_handler"
  role             = aws_iam_role.LambdaIamGenerateIamReport.arn
  filename         = data.archive_file.lambda_zip_inline_LambdaFunctionIamReport.output_path
  source_code_hash = data.archive_file.lambda_zip_inline_LambdaFunctionIamReport.output_base64sha256
  environment {
    variables = {
      SNS_TOPIC_ARN = var.iam_credentials_sns_topic_name,
      BUCKET_NAME   = var.iam_credentials_s3_bucket_name,
      BUCKET_KEY    = var.iam_credentials_s3_file_name
    }
  }
}

resource "aws_lambda_permission" "LambdaPermissionIamReport" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.LambdaFunctionIamReport.function_name
  principal     = "config.amazonaws.com"
}

resource "aws_iam_role" "LambdaIamGenerateIamReport" {
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

resource "aws_s3_bucket" "IamGenerateIamReport" {
  bucket = var.iam_credentials_s3_bucket_name
  acl    = "private"
}

resource "aws_s3_bucket_policy" "IamGenerateIamReportS3Policy" {
  bucket = var.iam_credentials_s3_bucket_name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowS3BucketAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.LambdaIamGenerateIamReport.arn}"
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




resource "aws_iam_role_policy_attachment" "LambdaIamRoleIamReportManagedPolicyRoleAttachment0" {
  role       = aws_iam_role.LambdaIamGenerateIamReport.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "LambdaIamRoleIamReportManagedPolicyRoleAttachment1" {
  role       = aws_iam_role.LambdaIamGenerateIamReport.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
