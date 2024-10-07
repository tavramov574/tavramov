data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_iam_role" "backup" {
  name               = "backup_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "backup_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role = aws_iam_role.backup.name
}

resource "aws_backup_vault" "backup" {
  name = "backup_vault"
}

resource "aws_backup_plan" "backup_plan" {
  name = "backup_plan"
  rule {
    rule_name         = "backup_plan_rule"
    target_vault_name = aws_backup_vault.backup.name
    schedule = "cron(0 12 * * ? *)"
    lifecycle {
      delete_after = 7
    }
  }
}

resource "aws_backup_selection" "backup_selection" {
  iam_role_arn = aws_iam_role.backup.arn
  name         = "backup_selection"
  plan_id      = aws_backup_plan.backup_plan.id
  resources = [
    "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:volume/*",
  ]
}