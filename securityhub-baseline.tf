module "secure-baseline_securityhub-baseline" {
  source  = "nozaq/secure-baseline/aws//modules/securityhub-baseline"
  version = "0.17.0"
}

resource "aws_securityhub_standards_subscription" "pci_321" {
  count         = var.securityhub_pci_standard_enabled ? 1 : 0
  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/pci-dss/v/3.2.1"
}

resource "aws_securityhub_standards_subscription" "aws_foundation" {
  count         = var.securityhub_aws_standard_enabled ? 1 : 0
  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/aws-foundational-security-best-practices/v/1.0.0"
}