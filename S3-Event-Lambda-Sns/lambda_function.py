import boto3
import os
import logging

# Initialize SNS client
sns_client = boto3.client('sns')

# Allowed file extensions
ALLOWED_EXTENSIONS = ('.jpg', '.jpeg', '.png')

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Environment variable for SNS Topic ARN
SNS_TOPIC_ARN = os.environ.get('SNS_TOPIC_ARN')

def lambda_handler(event, context):
    logger.info("Lambda triggered by S3 event")

    try:
        for record in event['Records']:
            bucket_name = record['s3']['bucket']['name']
            object_key = record['s3']['object']['key']

            logger.info(f"Processing file: s3://{bucket_name}/{object_key}")

            # Check if the file matches allowed extensions
            if object_key.lower().endswith(ALLOWED_EXTENSIONS):
                message = f"✅ New event photo uploaded: s3://{bucket_name}/{object_key}"

                # Publish to SNS
                response = sns_client.publish(
                    TopicArn=SNS_TOPIC_ARN,
                    Message=message,
                    Subject="📸 New Photo Upload Notification"
                )
                logger.info(f"SNS notification sent successfully. MessageId: {response['MessageId']}")
            else:
                logger.warning(f"Skipped file (unsupported file type): {object_key}")

    except Exception as e:
        logger.error(f"Error processing S3 event: {str(e)}")
        raise
