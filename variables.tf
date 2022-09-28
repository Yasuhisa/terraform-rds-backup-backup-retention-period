variable "db_subnet_ids" {
  description = "DB サブネットに指定するサブネット ID のリスト（2 つ以上のサブネット ID が必要）"
  type        = set(string)
  default     = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-xxxxxxxxxxxxxxxxx"]
}

variable "backup_iam_role_arn" {
  description = "AWS バックアップがバックアップジョブで使用する IAM ロール"
  type        = string
  // AWS Backup が使用する IAM ロールを作成し、作成した ARN へ変更してください
  // https://docs.aws.amazon.com/ja_jp/aws-backup/latest/devguide/iam-service-roles.html#default-service-roles
  default = "arn:aws:iam::123456789012:role/service-role/AWSBackupDefaultServiceRole"
}
