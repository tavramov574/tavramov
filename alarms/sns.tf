resource "aws_sns_topic" "alarms" {
  name = "alarms_name"
}

resource "aws_sns_topic_subscription" "alarms_subscription" {
  endpoint  = "tsvetan.avramov@helecloud.com"
  protocol  = "email"
  topic_arn = aws_sns_topic.alarms.arn
}