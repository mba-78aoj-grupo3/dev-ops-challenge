import json
import boto3

def handler(event, context):
    body = event['body'];

    client = boto3.client('sns');
    client.publish(
        TargetArn='arn',
        Message=json.dumps({'default': body}),
        MessageStructure='json'
    );

    response = {
        "statusCode": 200,
        "body": body
    }

    return response