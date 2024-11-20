import boto3
import json
import os
import uuid

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['DYNAMODB_TABLE'])

def lambda_handler(event, context):
    print("Received event:", json.dumps(event, indent=2))
    try:
        for record in event['Records']:
            print("Processing record:", json.dumps(record, indent=2))
            payload = record["body"]
            
            # If payload is a string (likely JSON), convert it to dict
            if isinstance(payload, str):
                try:
                    payload = json.loads(payload)
                except json.JSONDecodeError:
                    print("Warning: Payload is not JSON format")
            
            # Insert into DynamoDB
            item = {
                'orderID': str(uuid.uuid4()),
                'order': payload
            }
            print("Inserting item:", json.dumps(item, indent=2))
            table.put_item(Item=item)
        
        return {
            'statusCode': 200,
            'body': 'Successfully processed records'
        }
    
    except Exception as e:
        print(f"Error: {str(e)}")
        raise e
