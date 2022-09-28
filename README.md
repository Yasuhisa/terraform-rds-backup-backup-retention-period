# 概要
Terraform で RDS DB インスタンスのリソースでバックアップ保持期間を明示的に指定し、AWS Backup で別の保持期間を指定することで、apply しても差分が出続けるサンプルです。

詳しくは[[Terraform] RDS DB インスタンスに対して AWS Backup の継続的バックアップ（PITR）を取得したら plan に差分が出たので調べてみた](https://dev.classmethod.jp/articles/terraform-rds-backup-retention-period/)をご参照ください。

## 検証環境
```bash
$ terraform -v
Terraform v1.3.0
on darwin_arm64
+ provider registry.terraform.io/hashicorp/aws v4.32.0
+ provider registry.terraform.io/hashicorp/random v3.4.3
```

## 事前準備
`variables.tf` の以下ブロック内の `default` 値はお使いの環境に合わせて変更してください。

- db_subnet_ids
- backup_iam_role_arn

[参考](#参考)_の `AWSBackupDefaultServiceRole` を事前に作成してください。この IAM ロールはマネジメントコンソールからしか作成できないので、Terraform で管理したければ自作の IAM ロールで `AWSBackupDefaultServiceRole` と同じポリシーをアタッチすることをオススメします。

## 参考
[IAM サービスロール - AWS Backup](https://docs.aws.amazon.com/ja_jp/aws-backup/latest/devguide/iam-service-roles.html#default-service-roles)