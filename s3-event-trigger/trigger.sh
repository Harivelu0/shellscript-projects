#!/bin/bash

set -e  # Exit on error
set -x  # Print commands for debugging

# Store the AWS account ID in a variable
aws_account_id=$(aws sts get-caller-identity --query 'Account' --output text)
echo "AWS Account ID: $aws_account_id"

# Set variables
aws_region="us-east-1"
bucket_name="setchukos-bucket"
lambda_func_name="s3-lambda-function"
role_name="s3-lambda-sns"
email_address="xyz@gmail.com"

# Function to check if command succeeded
check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed"
        exit 1
    fi
}

# Create Lambda function directory and code
mkdir -p s3-lambda-function
cat > s3-lambda-function/s3-lambda-function.py << 'EOF'
import boto3
import json
import logging

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    try:
        logger.info("Received S3 event: " + json.dumps(event))
        
        sns = boto3.client('sns')
        s3 = boto3.client('s3')
        
        # Get bucket name and object key from event
        bucket = event['Records'][0]['s3']['bucket']['name']
        key = event['Records'][0]['s3']['object']['key']
        
        # List topics to find the correct one
        topics = sns.list_topics()
        topic_arn = None
        
        for topic in topics['Topics']:
            if ':s3-lambda-sns' in topic['TopicArn']:
                topic_arn = topic['TopicArn']
                break
        
        if not topic_arn:
            logger.error("SNS topic not found")
            raise Exception("SNS topic not found")
            
        logger.info(f"Found topic ARN: {topic_arn}")
        
        # Create message
        message = f"New file uploaded:\nBucket: {bucket}\nFile: {key}"
        
        # Publish to SNS
        response = sns.publish(
            TopicArn=topic_arn,
            Message=message,
            Subject=f'New file uploaded to {bucket}'
        )
        logger.info(f"Published to SNS: {json.dumps(response)}")
        
        return {
            'statusCode': 200,
            'body': json.dumps('Successfully processed S3 event')
        }
        
    except Exception as e:
        logger.error(f"Error: {str(e)}")
        raise e
EOF

# Create test file
echo "Test content for S3 trigger" > test_upload.txt

# Create or get existing IAM Role
if ! aws iam get-role --role-name "$role_name" 2>/dev/null; then
    echo "Creating new IAM role..."
    aws iam create-role \
        --role-name "$role_name" \
        --assume-role-policy-document '{
            "Version": "2012-10-17",
            "Statement": [{
                "Action": "sts:AssumeRole",
                "Effect": "Allow",
                "Principal": {
                    "Service": [
                        "lambda.amazonaws.com",
                        "s3.amazonaws.com",
                        "sns.amazonaws.com"
                    ]
                }
            }]
        }'
fi

# Get role ARN
role_arn=$(aws iam get-role --role-name "$role_name" --query 'Role.Arn' --output text)
echo "Role ARN: $role_arn"

# Attach necessary policies
aws iam attach-role-policy --role-name "$role_name" --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole || true
aws iam attach-role-policy --role-name "$role_name" --policy-arn arn:aws:iam::aws:policy/AmazonSNSFullAccess || true
aws iam attach-role-policy --role-name "$role_name" --policy-arn arn:aws:iam::aws:policy/AWSLambda_FullAccess || true

# Create S3 bucket if it doesn't exist
if ! aws s3api head-bucket --bucket "$bucket_name" 2>/dev/null; then
    echo "Creating S3 bucket..."
    aws s3api create-bucket --bucket "$bucket_name" --region "$aws_region"
fi

# Create Lambda deployment package
zip -r s3-lambda-function.zip ./s3-lambda-function

# Wait for role propagation
echo "Waiting for IAM role propagation..."
sleep 15

# Create or update Lambda function
if ! aws lambda get-function --function-name "$lambda_func_name" 2>/dev/null; then
    echo "Creating Lambda function..."
    aws lambda create-function \
        --region "$aws_region" \
        --function-name "$lambda_func_name" \
        --runtime "python3.8" \
        --handler "s3-lambda-function/s3-lambda-function.lambda_handler" \
        --memory-size 128 \
        --timeout 30 \
        --role "$role_arn" \
        --zip-file "fileb://./s3-lambda-function.zip"
else
    echo "Updating Lambda function..."
    aws lambda update-function-code \
        --function-name "$lambda_func_name" \
        --zip-file "fileb://./s3-lambda-function.zip"
fi

# Wait for Lambda to be ready
echo "Waiting for Lambda function to be ready..."
sleep 10

# Add S3 permission to invoke Lambda
echo "Adding Lambda permission for S3..."
aws lambda add-permission \
    --function-name "$lambda_func_name" \
    --statement-id "S3InvokeFunction" \
    --action "lambda:InvokeFunction" \
    --principal s3.amazonaws.com \
    --source-arn "arn:aws:s3:::$bucket_name" \
    --source-account "$aws_account_id" 2>/dev/null || true

# Create SNS topic
echo "Creating SNS topic..."
topic_arn=$(aws sns create-topic --name s3-lambda-sns --output json | jq -r '.TopicArn')
echo "SNS Topic ARN: $topic_arn"

# Subscribe email to SNS topic
echo "Subscribing email to SNS topic..."
aws sns subscribe \
    --topic-arn "$topic_arn" \
    --protocol email \
    --notification-endpoint "$email_address"

# Configure S3 event trigger
echo "Configuring S3 event trigger..."
aws s3api put-bucket-notification-configuration \
    --bucket "$bucket_name" \
    --notification-configuration '{
        "LambdaFunctionConfigurations": [{
            "LambdaFunctionArn": "'"arn:aws:lambda:${aws_region}:${aws_account_id}:function:${lambda_func_name}"'",
            "Events": ["s3:ObjectCreated:*"]
        }]
    }'

# Send test notification
echo "Sending test SNS notification..."
aws sns publish \
    --topic-arn "$topic_arn" \
    --subject "S3 Event Notification Setup Complete" \
    --message "Your S3 event notification system has been set up successfully. You will receive notifications when files are uploaded to your bucket."

echo "Setup completed successfully!"
echo "IMPORTANT: Check your email ($email_address) and confirm the SNS subscription!"
echo "To test the setup, upload a file to the S3 bucket:"
echo "aws s3 cp test_upload.txt s3://$bucket_name/"