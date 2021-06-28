import json

def handler(event, context):
    bookId = event['pathParameters']['id'];
    customerId = event['pathParameters']['customer'];
    
    body = {
        "message": "Venda efetuada!"
    }

    response = {
        "statusCode": 200,
        "body": json.dumps(body)
    }

    return response