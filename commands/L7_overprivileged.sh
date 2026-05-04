#!/bin/bash

cat <<'NOTES'
=== Steps to perform in AWS Console ===

1. Inspect the role:
   IAM -> Roles -> search "SendReceiptFunctionRole"
   Permissions tab -> open each inline policy
   Note wildcard resources: arn:aws:s3:::*  and  table/*
   Note attached managed policy: AmazonSESFullAccess

2. Run the IAM Policy Simulator:
   IAM -> Policy simulator (under Tools)
   Switch identity type from Users to Roles
   Select the receipt role
   Add S3 actions GetObject, PutObject -> resource arn:aws:s3:::some-other-bucket/key
   Click Run Simulation -> both should be Allowed

3. DynamoDB blast-radius test:
   Same simulator
   Add DynamoDB actions Scan, GetItem, PutItem, DeleteItem
   Resource: arn:aws:dynamodb:us-east-1:544719091426:table/unrelated-table
   All Allowed -> proves overreach

4. CloudTrail-based policy generation:
   CloudTrail -> Trails -> Create trail "dvsa-policygen-trail"
   Trigger the receipt function (place an order in DVSA)
   IAM -> Roles -> open the receipt role -> Generate policy
   Time period: Last 1 day, select trail "dvsa-policygen-trail"
   The generated policy will list ONLY: logs:CreateLogStream, kms:Decrypt, sts:GetCallerIdentity

NOTES

cat <<'OPTIONAL'
=== Optional: simulate post-compromise impact ===

# 1) Modify Lambda code (only for the lab):
#    AWS Console -> Lambda -> DVSA-SEND-RECEIPT-EMAIL -> edit send_receipt_email.py
#    Add at the top of lambda_handler:    print(dict(os.environ))
#    Click Deploy

# 2) Trigger by uploading a dummy file:
#    touch ~/empty
#    aws s3 cp ~/empty s3://[YOUR_RECEIPTS_BUCKET]/2020/20/20/trigger.raw

# 3) Read the printed environment from CloudWatch
#    Look for AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN

# 4) Export the harvested credentials locally:
#    export AWS_ACCESS_KEY_ID="..."
#    export AWS_SECRET_ACCESS_KEY="..."
#    export AWS_SESSION_TOKEN="..."

# 5) Demonstrate full table dump (proves blast radius):
#    aws dynamodb scan --table-name DVSA-ORDERS-DB --region us-east-1
OPTIONAL
