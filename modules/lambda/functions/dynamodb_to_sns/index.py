import boto3
import json
import os

# Initialize SNS client
sns = boto3.client('sns')
sns_topic_arn = os.environ['SNS_TOPIC_ARN']

def lambda_handler(event, context):
    print("Received event:", json.dumps(event, indent=2))
    try:
        for record in event['Records']:
            # Get the new image (the inserted/modified item)
            if 'NewImage' in record['dynamodb']:
                message = record['dynamodb']['NewImage']
                print("Processing message:", json.dumps(message, indent=2))
                
                # Publish to SNS
                response = sns.publish(
                    TopicArn=sns_topic_arn,
                    Message=json.dumps(message),
                    Subject='New DynamoDB Record'
                )
                print("SNS publish response:", json.dumps(response, indent=2))
        
        return {
            'statusCode': 200,
            'body': 'Successfully processed records'
        }
    
    except Exception as e:
        print(f"Error: {str(e)}")
        raise e
