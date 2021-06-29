import json
import boto3

def handler(event, context):
    body = event['body'];

    client = boto3.client('sns', region_name='us-east-1');
    publish_response = client.publish(
        TargetArn='arn:aws:sns:us-east-1:131167460192:requests-topic',
        Message=json.dumps({'default': body}),
        MessageStructure='json'
    );
    
    
    response_body = {
        "message": "Livro vendido com sucesso!",
        "body": body,
    }

    response = {
        "statusCode": 200,
        "body": json.dumps(response_body)
    }

    return response
