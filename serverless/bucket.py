import json
import boto3
import uuid

def handler(event, context):
    content = str(event);
    
    path = 'sell/';
    
    if 'book_name' in content :
        path = 'create/';
        
    req_id = uuid.uuid1()
    bucket_name = 'final-challenge-bucket'
    file_name = path + str(req_id) + '.txt'

    s3 = boto3.resource('s3')
    s3.Bucket(bucket_name).put_object(Key=file_name, Body=content)
