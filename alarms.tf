resource "aws_cloudwatch_metric_alarm" "alarm_rds_DatabaseConnections_writer" {
  # count               = var.enabled && var.cw_alarms ? 1 : 0
  alarm_name          = "${aws_rds_cluster.default.id}-alarm-rds-writer-DatabaseConnections"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Sum"
  threshold           = 20
  alarm_description   = "RDS Maximum connection Alarm for ${aws_rds_cluster.default.id} writer"
  alarm_actions       = [aws_sns_topic.aurora_alarm.arn]
  ok_actions          = [aws_sns_topic.aurora_alarm.arn]

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.default.id
    Role                = "WRITER"
  }

  tags = {
    cost_center = var.cost_center
    environment = var.environment
    project     = var.project
  }

}

resource "aws_cloudwatch_metric_alarm" "alarm_rds_CPU_writer" {
  # count               = var.enabled && var.cw_alarms ? 1 : 0
  alarm_name          = "${aws_rds_cluster.default.id}-alarm-rds-writer-CPU"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = 80
  alarm_description   = "RDS CPU Alarm for ${aws_rds_cluster.default.id} writer"
  alarm_actions       = [aws_sns_topic.aurora_alarm.arn]
  ok_actions          = [aws_sns_topic.aurora_alarm.arn]

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.default.id
    Role                = "WRITER"
  }

  tags = {
    cost_center = var.cost_center
    environment = var.environment
    project     = var.project
  }

}

resource "aws_sns_topic" "aurora_alarm" {
  name = "aurora_alarm"
  delivery_policy = jsonencode({
    "http" : {
      "defaultHealthyRetryPolicy" : {
        "minDelayTarget" : 20,
        "maxDelayTarget" : 20,
        "numRetries" : 3,
        "numMaxDelayRetries" : 0,
        "numNoDelayRetries" : 0,
        "numMinDelayRetries" : 0,
        "backoffFunction" : "linear"
      },
      "disableSubscriptionOverrides" : false,
      "defaultThrottlePolicy" : {
        "maxReceivesPerSecond" : 1
      }
    }
  })

  tags = {
    cost_center = var.cost_center
    environment = var.environment
    project     = var.project
  }
}

resource "aws_sns_topic_subscription" "topic_email_subscription" {
  topic_arn = aws_sns_topic.aurora_alarm.arn
  protocol  = "email"
  endpoint  = "fmercado00@gmail.com"
}