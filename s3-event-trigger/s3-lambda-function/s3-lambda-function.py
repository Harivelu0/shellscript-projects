import boto3
import json
import os
import logging

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    try:
        logger.info("Received S3 event: " + json.dumps(event))
        
        sns = boto3.client('sns')
        
        # Get bucket name and object key from event
        bucket = event['Records'][0]['s3']['bucket']['name']
        key = event['Records'][0]['s3']['object']['key']
        
        # Create or get SNS topic
        topic_name = 's3-lambda-sns'
        logger.info(f"Getting/Creating SNS topic: {topic_name}")
        
        # List existing topics to find ours
        topics = sns.list_topics()
        topic_arn = None
        
        for topic in topics['Topics']:
            if f":{topic_name}" in topic['TopicArn']:
                topic_arn = topic['TopicArn']
                break
                
        if not topic_arn:
            logger.info("Topic not found, creating new one")
            topic_response = sns.create_topic(Name=topic_name)
            topic_arn = topic_response['TopicArn']
        
        logger.info(f"Using Topic ARN: {topic_arn}")
        
        # Create message
        message = f"New file uploaded:\nBucket: {bucket}\nFile: {key}"
        
        # Publish to SNS
        logger.info("Publishing to SNS")
        response = sns.publish(
            TopicArn=topic_arn,
            Message=message,
            Subject=f'New file uploaded to {bucket}'
        )
        
        logger.info(f"SNS Publish Response: {json.dumps(response)}")
        
        return {
            'statusCode': 200,
            'body': json.dumps('Successfully processed S3 event and published to SNS')
        }
        
    except Exception as e:
        logger.error(f"Error: {str(e)}")
        raise e