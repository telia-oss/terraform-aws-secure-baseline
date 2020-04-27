module "secure-baseline_iam-baseline" {
  source  = "dailymuse/secure-baseline/aws//modules/iam-baseline"
  version = "0.20.0"


  aws_account_id                            = var.aws_account_id
  master_iam_role_enabled                   = var.master_iam_role_enabled
  master_iam_role_name                      = var.master_iam_role_name
  master_iam_role_policy_name               = var.master_iam_role_policy_name
  master_iam_role_policy_json               = var.master_iam_role_policy_json
  master_iam_role_permissions_boundary_arn  = var.master_iam_role_permissions_boundary_arn
  manager_iam_role_enabled                  = var.manager_iam_role_enabled
  manager_iam_role_name                     = var.manager_iam_role_name
  manager_iam_role_policy_name              = var.manager_iam_role_policy_name
  manager_iam_role_policy_json              = var.manager_iam_role_policy_json
  manager_iam_role_permissions_boundary_arn = var.manager_iam_role_permissions_boundary_arn
  support_iam_role_name                     = var.support_iam_role_name
  support_iam_role_policy_name              = var.support_iam_role_policy_name
  support_iam_role_principal_arns           = var.support_iam_role_principal_arns
  support_iam_role_permissions_boundary_arn = var.support_iam_role_permissions_boundary_arn
  max_password_age                          = var.max_password_age
  minimum_password_length                   = var.minimum_password_length
  password_reuse_prevention                 = var.password_reuse_prevention
  require_lowercase_characters              = var.require_lowercase_characters
  require_numbers                           = var.require_numbers
  require_symbols                           = var.require_symbols
  allow_users_to_change_password            = var.allow_users_to_change_password
  tags                                      = local.tags
}




