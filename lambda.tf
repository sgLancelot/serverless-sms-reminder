# IAM role for Lambda to send logs to Cloudwatch and call SNS topic
resource "aws_iam_role" "iam_for_lambda" {
  name               = "LambdaToSNSandCloudwatch"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "logs_attach" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_policy" "sns_publish" {
  name        = "sns_publish"
  path        = "/"
  description = "IAM policy for publishing to SNS topic from a lambda"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sns:Publish"
            ],
            "Resource": "arn:aws:sns:*:*:*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "sns_attach" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.sns_publish.arn
}

#################
#### Netflix ####
#################

resource "aws_lambda_function" "lambda_to_netflix_topic" {
  filename      = "sns-lambda.zip"
  function_name = "to_netflix_topic"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"
  runtime       = "nodejs12.x"

  environment {
    variables = {
      SNS_MESSAGE   = var.sns_message_1
      SNS_TOPIC_ARN = aws_sns_topic.netflix_topic.arn
    }
  }
}

resource "aws_lambda_permission" "allow_cloudwatch_netflix" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_to_netflix_topic.function_name
  principal     = "events.amazonaws.com"
}

##############
#### Cast ####
##############

resource "aws_lambda_function" "lambda_to_cast_topic" {
  filename      = "sns-lambda.zip"
  function_name = "to_cast_topic"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"
  runtime       = "nodejs12.x"

  environment {
    variables = {
      SNS_MESSAGE   = var.sns_message_2
      SNS_TOPIC_ARN = aws_sns_topic.cast_topic.arn
    }
  }
}

resource "aws_lambda_permission" "allow_cloudwatch_cast" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_to_cast_topic.function_name
  principal     = "events.amazonaws.com"
}