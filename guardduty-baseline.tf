module "secure-baseline_guardduty-baseline" {
  source  = "nozaq/secure-baseline/aws//modules/guardduty-baseline"
  version = "0.17.0"

  enabled = var.guard_duty_enabled
  disable_email_notification = var.disable_email_notification
  finding_publishing_frequency = var.finding_publishing_frequency
  invitation_message =var.invitation_message
  master_account_id = var.master_account_id
  member_accounts = var.member_accounts
}

