module "secure-baseline_vpc-baseline" {
  source  = "nozaq/secure-baseline/aws//modules/vpc-baseline"
  version = "0.20.0"


  enabled                    = var.vpc_logs_enabled
  vpc_log_group_name         = var.vpc_log_group_name
  vpc_flow_logs_iam_role_arn = var.vpc_flow_logs_iam_role_arn
  vpc_log_retention_in_days  = var.vpc_log_retention_in_days
  tags                       = local.tags

}
