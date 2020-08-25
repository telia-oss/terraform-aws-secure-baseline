locals {
  tags = merge(
    var.tags,
    map("Name", var.global_name),
    map("Project", var.global_project),
    map("Environment", var.local_environment)
  )
}

module "secure-baseline_alarm-baseline" {
  source  = "nozaq/secure-baseline/aws//modules/alarm-baseline"
  version = "0.20.0"

  enabled                   = var.cloudwatch_enabled
  alarm_namespace           = var.alarm_namespace
  cloudtrail_log_group_name = var.cloudtrail_log_group_name
  sns_topic_name            = var.sns_topic_name
  tags                      = local.tags
}
