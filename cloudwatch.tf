#################
#### Netflix ####
#################
resource "aws_cloudwatch_event_rule" "monthly_netflix" {
  schedule_expression = "cron(16 11 1 * ? *)"
  name                = "Cron-Lambda-SNS-Netflix"
}

resource "aws_cloudwatch_event_target" "sns_netflix" {
  rule = aws_cloudwatch_event_rule.monthly_netflix.name
  arn  = aws_lambda_function.lambda_to_netflix_topic.arn
}

##############
#### Cast ####
##############

resource "aws_cloudwatch_event_rule" "monthly_cast" {
  schedule_expression = "cron(0 11 1 * ? *)"
  name                = "Cron-Lambda-SNS-Cast"
}

resource "aws_cloudwatch_event_target" "sns_cast" {
  rule = aws_cloudwatch_event_rule.monthly_cast.name
  arn  = aws_lambda_function.lambda_to_cast_topic.arn
}