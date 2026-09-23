import boto3
from botocore.client import Config

s3 = boto3.client('s3',
    endpoint_url='http://minio:9000',
    aws_access_key_id='minioadmin',
    aws_secret_access_key='minioadmin123',
    config=Config(signature_version='s3v4')
)

buckets = ['oil-data-lake']

for bucket in buckets:
    try:
        s3.create_bucket(Bucket=bucket)
        print(f"Created bucket: {bucket}")
    except Exception as e:
        print(f"Bucket {bucket} exists or error: {e}")