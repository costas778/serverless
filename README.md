**Building a Proof of Concept for a Serverless Solution**
This Terraform solution provides you with a declarative script to help to build a proof of concept for a serverless solution in the AWS Cloud.

Suppose you have a customer that needs a serverless web backend hosted on AWS. The customer sells cleaning supplies and often sees spikes in demand for their website, which means that they need an architecture that can easily scale in and out as demand changes. The customer also wants to ensure that the application has decoupled application components.

The following architectural diagram shows the flow for the serverless solution that you will build.

![image](https://github.com/user-attachments/assets/fbf8c820-8164-46c6-ae9f-b97794795670)

Let's break down what the services above in the diagram do.

**Amazon API Gateway**
Amazon API Gateway is a fully managed service that enables developers to create, publish, maintain, monitor, and secure APIs at any scale. Here are its key functions: 

1. Acts as a "Front Door":

Serves as an entry point for applications to access data, business logic, or functionality from backend services
Can connect to services like AWS Lambda, EC2, or any web application

2. Core Features:

Traffic Management: Handles large numbers of concurrent API calls
Authorization & Security: Controls access using IAM roles, Lambda authorizers, or OAuth
Monitoring & Metrics: Tracks API usage and performance

The service handles all the heavy lifting of accepting and processing API calls, including traffic management, authorization, monitoring, and version management, allowing developers to focus on their application logic.




Ok we need a few prerequisite to make this work. 

This is what I used:
A WSL Ubuntu image (20.x) with GIT, Terraform, zip, AWSCLI and VSC loaded. 
A AWS sandbox environemnt (you can also use a FREE tier Account)
A GITHUB account (recommended)

**Steps**

1. git clone https://github.com/costas778/serverless.git

2. aws configure

AWS Access Key ID [****************HF4N]: 

AWS Secret Access Key [****************GUzc]: 

Default region name [us-east-1]: 

Default output format [None]: 

**NOTE:** the above are an example. You can create these with your account in IAM.


3. terraform init 

4. terraform fmt

5. terraform plan (I recommend you copy and paste this generated output in a text file for troubleshooting purposes)

6. terraform apply

When prompted:
place your Account ID (a bunch of numbers)
place an email address (needs to be a live address for verification purposes)
yes

If successful you will see a message such as follows:

**Apply complete! Resources: 27 added, 0 changed, 0 destroyed.

Outputs:

api_gateway_endpoint = "https://b7rsjzyxx3.execute-api.us-east-1.amazonaws.com/poc/message"
dynamodb_table_name = "poc-table"
sns_topic_arn = "arn:aws:sns:us-east-1:533267031846:poc-topic"**

**NOTE:** Please copy these details and store them for later use.
**NOTE** If you need to retrive this output simply use the terraform output account.


**Post Install Tests**

**Trigger the Gateway API**

curl -X POST \
  https://b7rsjzyxx3.execute-api.us-east-1.amazonaws.com/poc/message \
  -H 'Content-Type: application/json' \
  -d '{
    "message": "Testing complete flow after fix",
    "timestamp": "2024-02-20T13:00:00Z"
}'

**NOTE:** your URL above will be different.

or something more complex

curl -X POST \
-H "Content-Type: application/json" \
-d '{
  "message": "Complex test message",
  "priority": "high",
  "timestamp": "2024-11-20T17:00:00Z",
  "metadata": {
    "category": "test",
    "tags": ["important", "test"]
  }
}' \
https://b7rsjzyxx3.execute-api.us-east-1.amazonaws.com/poc/message

A more complex example

**Locate the NON SQL table**

aws dynamodb scan --table-name poc-table --region us-east-1

or To query messages within a specific time range, we can use a scan with a filter expression:


aws dynamodb scan \
    --table-name poc-table \
    --filter-expression "#ts BETWEEN :start_time AND :end_time" \
    --expression-attribute-names '{"#ts": "timestamp"}' \
    --expression-attribute-values '{
        ":start_time": {"S": "2024-11-20T16:00:00Z"},
        ":end_time": {"S": "2024-11-20T17:00:00Z"}
    }'


aws dynamodb scan \
    --table-name poc-table \
    --filter-expression "begins_with(pk, :prefix)" \
    --expression-attribute-values '{":prefix": {"S": "MSG#"}}' \
    --return-consumed-capacity TOTAL


More querries 

aws dynamodb query \Lc
    --table-name poc-table \
    --key-condition-expression "begins_with(pk, :prefix)" \
    --expression-attribute-values '{":prefix": {"S": "MSG#"}}'aws dynamodb scan --table-name poc-table --region us-east-1

aws dynamodb query \
    --table-name poc-table \
    --key-condition-expression "begins_with(pk, :prefix)" \
    --expression-attribute-values '{":prefix": {"S": "MSG#"}}'

aws sqs get-queue-attributes \
  --queue-url $(aws sqs get-queue-url --queue-name poc-queue --region us-east-1 --query 'QueueUrl' --output text) \
  --attribute-names ApproximateNumberOfMessages ApproximateNumberOfMessagesNotVisible \
  --region us-east-1

aws sqs get-queue-attributes \
    --queue-url https://sqs.us-east-1.amazonaws.com/533267031846/poc-queue \
    --attribute-names ApproximateNumberOfMessages


**Troubleshooting commands (for both Lambda scripts)**

aws logs get-log-events \
  --log-group-name /aws/lambda/poc-sqs-to-dynamodb \
  --log-stream-name $(aws logs describe-log-streams \
    --log-group-name /aws/lambda/poc-sqs-to-dynamodb \
    --region us-east-1 \
    --order-by LastEventTime \
    --descending \
    --limit 1 \
    --query 'logStreams[0].logStreamName' \
    --output text) \
  --region us-east-1

aws logs get-log-events \
    --log-group-name /aws/lambda/poc-sqs-to-dynamodb \
    --log-stream-name $(aws logs describe-log-streams --log-group-name /aws/lambda/poc-sqs-to-dynamodb --order-by LastEventTime --descending --limit 1 --query 'logStreams[0].logStreamName' --output text)

aws logs tail /aws/lambda/poc-sqs-to-dynamodb --since 5m



aws logs get-log-events \
  --log-group-name /aws/lambda/poc-dynamodb-to-sns \
  --log-stream-name $(aws logs describe-log-streams \
    --log-group-name /aws/lambda/poc-dynamodb-to-sns \
    --region us-east-1 \
    --order-by LastEventTime \
    --descending \
    --limit 1 \
    --query 'logStreams[0].logStreamName' \
    --output text) \
  --region us-east-1

**Further Troubleshooting:**

aws logs get-log-events \
  --log-group-name /aws/lambda/poc-sqs-to-dynamodb \
  --log-stream-name $(aws logs describe-log-streams \
    --log-group-name /aws/lambda/poc-sqs-to-dynamodb \
    --region us-east-1 \
    --order-by LastEventTime \
    --descending \
    --limit 1 \
    --query 'logStreams[0].logStreamName' \
    --output text) \
  --region us-east-1 \
  --start-time $(date -d '1 hour ago' +%s000) \
  --limit 100

aws logs get-log-events \
  --log-group-name /aws/lambda/poc-sqs-to-dynamodb \
  --log-stream-name $(aws logs describe-log-streams \
    --log-group-name /aws/lambda/poc-sqs-to-dynamodb \
    --region us-east-1 \
    --order-by LastEventTime \
    --descending \
    --limit 1 \
    --query 'logStreams[0].logStreamName' \
    --output text) \
  --region us-east-1 \
  --output json | jq '.events[].message'

**Note:** It's likely you will need to install an app to be able to read JSON connect within your WSL.










