import json

def handler(event, context):
    bookName = event['pathParameters']['name'];
    bookId = event['pathParameters']['id'];
    bookPrice = event['pathParameters']['price'];
    
    body = {
        "message": f'{name} foi criado com sucesso!'
    }

    response = {
        "statusCode": 200,
        "body": json.dumps(body)
    }

    return response