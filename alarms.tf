resource "aws_cloudwatch_metric_alarm" "alarm_rds_DatabaseConnections_writer" {
  count               = var.enabled && var.cw_alarms ? 1 : 0
  alarm_name          = "${aws_rds_cluster.default[0].id}-alarm-rds-writer-DatabaseConnections"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.cw_eval_period_connections
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Sum"
  threshold           = var.cw_max_conns
  alarm_description   = "RDS Maximum connection Alarm for ${aws_rds_cluster.default[0].id} writer"
  alarm_actions       = [var.cw_sns_topic]
  ok_actions          = [var.cw_sns_topic]

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.default[0].id
    Role                = "WRITER"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_rds_CPU_writer" {
  count               = var.enabled && var.cw_alarms ? 1 : 0
  alarm_name          = "${aws_rds_cluster.default[0].id}-alarm-rds-writer-CPU"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.cw_eval_period_cpu
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = var.cw_max_cpu
  alarm_description   = "RDS CPU Alarm for ${aws_rds_cluster.default[0].id} writer"
  alarm_actions       = [aws_sns_topic.aurora_alarm.arn]
  ok_actions          = [aws_sns_topic.aurora_alarm.arn]

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.default[0].id
    Role                = "WRITER"
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
}

resource "aws_sns_topic_subscription" "topic_email_subscription" {
  topic_arn = aws_sns_topic.aurora_alarm.arn
  protocol  = "email"
  endpoint  = "fmercado00@gmail.com"
}