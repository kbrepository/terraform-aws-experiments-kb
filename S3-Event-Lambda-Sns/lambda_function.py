import boto3
import os

sns_client = boto3.client('sns')

def lambda_handler(event, context):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        message = f"New invoice uploaded: s3://{bucket}/{key}"

        sns_client.publish(
            TopicArn=os.environ['SNS_TOPIC_ARN'],
            Message=message,
            Subject="Invoice Upload Notification"
        )
