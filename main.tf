# DB パラメータグループ
resource "aws_db_parameter_group" "example" {
  name        = "mysql-8-0-parameter-group"
  description = "For MySQL 8.0 Custom Parameter Group"
  family      = "mysql8.0"
}

# DB サブネットグループ
resource "aws_db_subnet_group" "example" {
  name        = "blog-db-subnet-group"
  description = "DB subnet group for blog examle."
  subnet_ids  = var.db_subnet_ids
}

# MySQL パスワード
resource "random_password" "example" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# RDS for MySQL DB インスタンス
resource "aws_db_instance" "example" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0.28"
  instance_class       = "db.t3.micro"
  db_subnet_group_name = aws_db_subnet_group.example.name
  username             = "foo"
  password             = random_password.example.result
  parameter_group_name = aws_db_parameter_group.example.name
  skip_final_snapshot  = true

  ##############
  # 差分が出る例 #
  ##############
  // AWS Backup で取得するため RDS の自動バックアップは無効にする
  # backup_retention_period = 0

  ################
  # 差分が出ない例 #
  ################
  // backup_retention_period を書かない、もしくは null を指定する
  backup_retention_period = null
}

# バックアップボールト
resource "aws_backup_vault" "example" {
  name          = "tf_example_backup_vault"
  force_destroy = true
}

# バックアッププラン
resource "aws_backup_plan" "example" {
  name = "tf_example_backup_plan"

  rule {
    rule_name                = "tf_example_backup_rule"
    target_vault_name        = aws_backup_vault.example.name
    schedule                 = "cron(10 * * * ? *)" // 毎時 10 分
    enable_continuous_backup = true

    lifecycle {
      delete_after = 7
    }
  }
}

# バックアップセレクション（ARN でバックアップ対象を指定）
resource "aws_backup_selection" "example" {
  iam_role_arn = var.backup_iam_role_arn
  name         = "tf_example_backup_selection"
  plan_id      = aws_backup_plan.example.id

  resources = [
    aws_db_instance.example.arn
  ]
}
