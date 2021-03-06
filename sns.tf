provider "aws" {
  region = var.region
}
################
# Netflix Topic
################
# create topic
resource "aws_sns_topic" "netflix_topic" {
  name = var.topic_1
}

# create sms subscription
resource "aws_sns_topic_subscription" "alex_phone" {
  topic_arn = aws_sns_topic.netflix_topic.id
  protocol  = "sms"
  endpoint  = var.phone_1
}

resource "aws_sns_topic_subscription" "zk_phone_netflix" {
  topic_arn = aws_sns_topic.netflix_topic.id
  protocol  = "sms"
  endpoint  = var.phone_5
}

#############
# Cast Topic
#############

resource "aws_sns_topic" "cast_topic" {
  name = var.topic_2
}

resource "aws_sns_topic_subscription" "zx_phone_cast" {
  topic_arn = aws_sns_topic.cast_topic.id
  protocol  = "sms"
  endpoint  = var.phone_2
}

resource "aws_sns_topic_subscription" "yk_phone" {
  topic_arn = aws_sns_topic.cast_topic.id
  protocol  = "sms"
  endpoint  = var.phone_3
}

resource "aws_sns_topic_subscription" "qh_phone" {
  topic_arn = aws_sns_topic.cast_topic.id
  protocol  = "sms"
  endpoint  = var.phone_4
}

# setting this as transactional because promotional and transactional sms costs the same in AP-Southeast-1
resource "aws_sns_sms_preferences" "update_sms_prefs" {
  default_sms_type = "Transactional"
}