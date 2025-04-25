provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "invoices" {
  bucket = "global-invoice-bucket-demo"
}

resource "aws_sns_topic" "notify_finance" {
  name = "invoice-upload-topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.notify_finance.arn
  protocol  = "email"
  endpoint  = "your-email@example.com"  # Replace with actual email
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_s3_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_basic" {
  name       = "lambda-basic"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "lambda_sns_publish_policy" {
  name        = "lambda-sns-publish-policy"
  description = "Allows Lambda to publish messages to the SNS topic"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "sns:Publish",
      Resource = aws_sns_topic.notify_finance.arn
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_sns_publish_attach" {
  name       = "lambda-sns-publish-attachment"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = aws_iam_policy.lambda_sns_publish_policy.arn
}


data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function_payload.zip"
}
resource "aws_lambda_function" "process_upload" {
  function_name = "processInvoiceUpload"
  role          = aws_iam_role.lambda_exec.arn
  runtime       = "python3.9"
  handler       = "lambda_function.lambda_handler"
  filename      = "lambda_function_payload.zip"
  source_code_hash = data.archive_file.lambda.output_base64sha256

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.notify_finance.arn
    }
  }
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.process_upload.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.invoices.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.invoices.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.process_upload.arn
    events              = ["s3:ObjectCreated:*"]
  }
}
