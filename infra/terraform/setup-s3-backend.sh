#!/bin/bash
set -e
aws dynamodb create-table \
  --billing-mode PROVISIONED \
  --provisioned-throughput '{ "ReadCapacityUnits": 20, "WriteCapacityUnits": 20 }' \
  --table-name propile-terraform-state-lock \
  --attribute-definitions '[ { "AttributeName": "LockID", "AttributeType": "S" } ]' \
  --key-schema '[{"AttributeName": "LockID", "KeyType": "HASH" }]' \
  --tags '[ { "Key": "Name", "Value": "Terraform State Lock File" } ]'

aws s3 mb s3://xpdays-propile-terraform-state