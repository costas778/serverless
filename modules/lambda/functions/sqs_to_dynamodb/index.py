import json
import uuid
import boto3
import os  # Add this import
from datetime import datetime

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['DYNAMODB_TABLE'])  # Keep using environment variable

def lambda_handler(event, context):
    try:
        for record in event['Records']:
            print(f"Processing record: {record}")
            
            # Parse the message body
            message_body = json.loads(record['body'])
            
            # Generate a unique message ID
            message_id = str(uuid.uuid4())
            
            # Use the timestamp from the message or generate current time
            timestamp = message_body.get('timestamp') or datetime.utcnow().isoformat()
            
            # Create item for DynamoDB
            item = {
                'pk': f"MSG#{message_id}",           # Partition key
                'timestamp': timestamp,               # Sort key
                'message': message_body.get('message'),
                'status': 'PROCESSED',
                'created_at': datetime.utcnow().isoformat()
            }
            
            print(f"Inserting item: {json.dumps(item, indent=2)}")
            
            # Put item in DynamoDB
            table.put_item(Item=item)
            
        return {
            'statusCode': 200,
            'body': json.dumps('Messages processed successfully')
        }
    except Exception as e:
        print(f"Error: {str(e)}")
        raise e
