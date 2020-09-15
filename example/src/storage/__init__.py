import os
import boto3
from botocore.exceptions import ClientError

# define s3 client, define endpoint_url to use localhost for local development
s3 = boto3.client('s3', endpoint_url="http://localhost:4566") if os.getenv(
    "LAMBDA_EXECUTOR", None) else boto3.client('s3')


def get_object(bucket_name, bucket_key):
    return s3.get_object(Bucket=bucket_name, Key=bucket_key)


def read_csv_data(csv_object, delimiter=';'):
    csv_file = csv_object['Body'].read().decode('utf-8').splitlines(True)
    header = csv_file[0].strip().split(delimiter)
    items = [row.strip().split(delimiter) for row in csv_file[1:]]
    return header, items
